// ============================================================
//  Bottle Builder — bocaux et bouteilles à visser, paramétriques
//  Pièce à générer : part = "body" | "lid" | "both"
// ============================================================
// Toutes les cotes sont en millimètres.

part = "both";

// --- Corps -------------------------------------------------
body_d   = 70;    // diamètre extérieur, mesuré sur les nervures
body_h   = 100;   // hauteur du fût
wall     = 2.0;   // épaisseur de paroi AU PLUS MINCE (fond de cannelure)
floor_t  = 2.4;   // épaisseur du fond
base_ch  = 1.0;   // chanfrein du bas, pour décoller proprement du plateau

// --- Cannelures --------------------------------------------
flutes   = 12;    // nombre de cannelures ; 0 = fût lisse
flute_d  = 2.2;   // profondeur
flute_w  = 5.0;   // rayon de l'outil : plus grand = cannelure plus large
twist    = 220;   // vrille sur la HAUTEUR CANNELÉE, en degrés
flute_bot = 12;   // bande lisse conservée en bas
flute_top = 10;   // ... et en haut, sous l'épaule

// --- Épaule et col -----------------------------------------
shoulder_h = 10;  // hauteur du congé entre le fût et le col
neck_d     = 46;  // diamètre extérieur du col, sous filet
neck_h     = 14;  // hauteur filetée

// --- Filetage ----------------------------------------------
thread_lead   = 6;    // avance axiale par tour
thread_depth  = 1.4;  // saillie radiale du filet
thread_starts = 3;    // nombre de filets : 3 = ouverture en 1/3 de tour
thread_clear  = 0.35; // jeu au montage (par flanc)

// --- Couvercle ---------------------------------------------
lid_top   = 2.4;  // épaisseur du dessus
lid_wall  = 2.4;  // épaisseur de la jupe
lid_extra = 2.0;  // garde entre le haut du col et le plafond
knurl     = 44;   // stries de préhension ; 0 = lisse
knurl_d   = 0.6;  // leur profondeur

$fn = 128;

// ------------------------------------------------------------
// Outils
// ------------------------------------------------------------
function arc(r, a0, a1, n) =
    [for (i = [0:n]) let(a = a0 + (a1 - a0) * i / n) [r * cos(a), r * sin(a)]];

// Une cannelure : un cylindre vrillé qu'on retire du fût. On vrille
// l'OUTIL et non le profil du fût — un profil cannelé est concave, et
// en le vrillant les tranches voisines se recoupent : le maillage sort
// ouvert. Un cercle, lui, reste convexe quoi qu'il arrive.
// z0/z1 : la cannelure ne court pas d'un bout à l'autre, elle laisse
// une bande lisse en haut et en bas — c'est un encaissement, pas une
// gorge traversante. La vrille se compte sur cette longueur-là.
module cannelure(r, prof, larg, z0, z1, vrille) {
    h = z1 - z0;
    if (h > 0.5)
        translate([0, 0, z0])
            linear_extrude(height = h, twist = vrille,
                           slices = max(ceil(h / 2), ceil(abs(vrille) / 4), 12),
                           convexity = 4)
                translate([r + larg - prof, 0]) circle(r = larg, $fn = 32);
}

// Filet trapézoïdal balayé en hélice.
// linear_extrude(twist) balaie un profil 2D le long d'une hélice ; en le
// faisant LARGE au fond et ÉTROIT en crête, la section (r,z) obtenue est
// le trapèze cherché. Un filet carré tiendrait moins bien la couche.
module filet(r, prof, pas, tours, deps = 1, jeu = 0) {
    esp = pas / deps;                        // pas entre filets voisins
    ar  = 360 * (0.45 * esp + jeu) / pas;    // ouverture au fond
    ac  = 360 * (0.25 * esp + jeu) / pas;    // ouverture en crête
    for (k = [0 : deps - 1])
        rotate([0, 0, k * 360 / deps])
            linear_extrude(height = pas * tours, twist = -360 * tours,
                           slices = max(ceil(tours * 60), 12), convexity = 8)
                polygon(concat(arc(r - jeu, -ar / 2, ar / 2, 16),
                               arc(r + prof + jeu, ac / 2, -ac / 2, 16)));
}

// ------------------------------------------------------------
// Cotes dérivées
// ------------------------------------------------------------
body_r  = body_d / 2;
neck_r  = neck_d / 2;
// rayon intérieur : mesure depuis le FOND de cannelure, sinon la paroi
// annoncee serait celle des nervures et le pot percerait dans les gorges
in_r    = body_r - flute_d - wall;
neck_in = neck_r - wall;
z_ep    = body_h;                    // depart de l'epaule
z_col   = body_h + shoulder_h;       // depart du col
h_tot   = z_col + neck_h;            // hauteur totale du corps
tours   = neck_h / thread_lead;      // nombre de tours de filet
// couvercle
lid_in_r = neck_r + thread_clear;                  // alésage
lid_out_r = lid_in_r + thread_depth + lid_wall;    // rayon extérieur
lid_h    = neck_h + lid_extra + lid_top;

// contenance approchée, en millilitres
capacite = PI * pow(in_r, 2) * (z_col - floor_t) / 1000;

// ------------------------------------------------------------
// Corps
// ------------------------------------------------------------
module corps() {
    difference() {
        union() {
            // fût, chanfreiné en bas pour que la première couche n'ait
            // pas d'arête vive et se décolle sans écaillage. Le cône
            // doit couvrir TOUTE la hauteur : plus court, l'intersection
            // raserait le haut du fût et le col partirait tout seul.
            intersection() {
                cylinder(r = body_r, h = body_h);
                cylinder(r1 = body_r - base_ch,
                         r2 = body_r - base_ch + body_h + 2, h = body_h + 2);
            }
            // épaule
            translate([0, 0, z_ep])
                cylinder(r1 = body_r - flute_d, r2 = neck_r, h = shoulder_h);
            // col
            translate([0, 0, z_col]) cylinder(r = neck_r, h = neck_h);
            // filet extérieur, arrêté juste sous le haut du col
            translate([0, 0, z_col + 0.6])
                filet(neck_r - 0.2, thread_depth, thread_lead,
                      max(tours - 0.25, 0.5), thread_starts);
        }
        // cannelures vrillées
        if (flutes > 0)
            for (i = [0 : flutes - 1])
                rotate([0, 0, i * 360 / flutes])
                    cannelure(body_r, flute_d, flute_w,
                              flute_bot, body_h - flute_top, twist);
        // creux : fût puis col, d'un seul tenant
        translate([0, 0, floor_t]) {
            cylinder(r = in_r, h = z_ep - floor_t + 0.01);
            translate([0, 0, z_ep - floor_t])
                cylinder(r1 = in_r, r2 = neck_in, h = shoulder_h);
            translate([0, 0, z_col - floor_t])
                cylinder(r = neck_in, h = neck_h + 1);
        }
    }
}

// ------------------------------------------------------------
// Couvercle — imprimé à l'endroit, dessus sur le plateau
// ------------------------------------------------------------
module couvercle() {
    difference() {
        union() {
            cylinder(r = lid_out_r, h = lid_h);
            // stries de préhension
            if (knurl > 0)
                for (i = [0 : knurl - 1])
                    rotate([0, 0, i * 360 / knurl])
                        translate([lid_out_r, 0, 0])
                            cylinder(r = knurl_d, h = lid_h, $fn = 12);
        }
        // alésage
        translate([0, 0, lid_top])
            cylinder(r = lid_in_r + thread_depth, h = lid_h);
        // le filet est ajouté en NÉGATIF : on retire la gorge dans
        // laquelle viendra le filet du col
        translate([0, 0, lid_top + 0.4])
            filet(lid_in_r - 0.2, thread_depth + 0.2, thread_lead,
                  tours + 0.5, thread_starts, thread_clear);
        // le col ne doit pas toucher le plafond
        translate([0, 0, lid_top])
            cylinder(r = lid_in_r, h = lid_h);
    }
}

// ------------------------------------------------------------
// Sortie
// ------------------------------------------------------------
if (part == "body") corps();
if (part == "lid")  couvercle();
if (part == "both") {
    corps();
    translate([body_d + 12, 0, 0]) couvercle();
}
echo(str("Contenance ~ ", round(capacite), " ml ; hauteur totale ",
         h_tot, " mm"));
