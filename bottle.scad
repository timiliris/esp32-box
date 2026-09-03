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

// --- Double paroi ------------------------------------------
// Une lame d'air scellée entre deux parois, façon isotherme. Elle court
// sur les FLANCS seulement : sous le fond, elle imposerait un pont
// large comme tout le pot, que rien ne peut imprimer. C'est de toute
// façon par les flancs que part l'essentiel de la chaleur.
// En haut, l'épaule referme la lame — un pont de la largeur du vide,
// quelques millimètres, que la buse franchit sans peine.
iso      = false; // true = double paroi
iso_n    = 28;    // nombre de tuyaux d'air ; 0 = une lame continue
iso_gap  = 3;     // Ø d'un tuyau, ou épaisseur de la lame
iso_wall = 1.2;   // paroi intérieure, celle qui touche le contenu
iso_base = 4;     // hauteur pleine conservée en bas
iso_lid  = true;  // isole AUSSI le dessus du bouchon : sans lui, tout
                  // repart par le couvercle dès qu'on ferme le pot
iso_skirt = true; // ... et sa jupe, qui enveloppe le col sur toute la
                  // hauteur filetée. La jupe s'épaissit d'autant.
// Des tuyaux plutôt qu'une lame continue : les cloisons qui les
// séparent lient les deux coques, le pot devient bien plus rigide, et
// il n'y a plus un seul pont à franchir — ce ne sont que des trous
// verticaux. L'air reste piégé, colonne par colonne.

// --- Épaule et col -----------------------------------------
shoulder_h = 10;  // hauteur du congé entre le fût et le col
neck_d     = 46;  // diamètre extérieur du col, sous filet
neck_h     = 18;  // hauteur filetée

// --- Filetage ----------------------------------------------
// L'épaisseur d'un filet vaut 0.45 x pas / nombre de départs. Sous
// 1.2 mm il ne fait plus que trois couches et s'arrache : d'où un pas
// large plutôt qu'un pas fin, même à trois départs.
thread_lead   = 10;   // avance axiale par tour
thread_depth  = 1.8;  // saillie radiale du filet
thread_starts = 3;    // nombre de filets : 3 = ouverture en 1/3 de tour
thread_clear  = 0.35; // jeu au montage (par flanc)

// --- Porte-étiquette ---------------------------------------
// Un méplat raboté dans le fût, et par-dessus un cadre dans lequel on
// glisse une languette PAR LE HAUT. Rien ne surplombe : la fente est
// ouverte en haut, la fenêtre du cadre est un simple pont.
label      = false;  // true = porte-étiquette
// La languette est en PORTRAIT : plus haute que large, elle suit le
// fût et n'a pas à épouser la courbure sur une grande largeur.
// Bande haute, sur presque tout le fût : c'est le méplat qui suit le
// cadre, pas l'inverse. Raccourcis label_h et le méplat se réduit avec.
label_w    = 22;     // largeur de la languette
label_h    = 76;     // sa hauteur
label_card = 1.2;    // son épaisseur (fente = celle-ci + 0.5 de jeu)
label_front = 1.2;   // épaisseur de la face avant du cadre
label_rail = 3;      // largeur du cadre
label_z    = 10;     // hauteur du bas du cadre sur le fût
// Le méplat doit être PLUS PROFOND que les cannelures, sinon celles-ci
// le traversent et le rainurent : le cadre ne pose plus à plat.
label_flat = 2.6;    // profondeur du méplat

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
in_r    = body_r - flute_d - wall;      // face interne de la paroi externe
// rayon utile : ce qui reste au contenu une fois la lame et la paroi
// intérieure déduites
use_r   = iso ? in_r - iso_gap - iso_wall : in_r;
neck_in = neck_r - wall;
z_ep    = body_h;                    // depart de l'epaule
z_col   = body_h + shoulder_h;       // depart du col
h_tot   = z_col + neck_h;            // hauteur totale du corps
tours   = neck_h / thread_lead;      // nombre de tours de filet
// couvercle
lid_in_r = neck_r + thread_clear;                  // alésage
// rayon extérieur ; la jupe isolée s'épaissit de la lame et de sa peau
lid_skin = (iso && iso_skirt) ? iso_gap + iso_wall : 0;
lid_out_r = lid_in_r + thread_depth + lid_wall + lid_skin;
// couronne des tuyaux de jupe, et leur nombre à cloison constante
lid_tube_r = lid_in_r + thread_depth + lid_wall + iso_gap / 2;
lid_tube_n = max(floor(2 * PI * lid_tube_r / (iso_gap + 1.6)), 4);
// Le bouchon SUIT L'ÉPAULE : sa jupe se prolonge en CÔNE parallèle au
// congé — épaisseur constante — jusqu'à venir affleurer le fût. Fermé,
// la ligne monte du fût au dessus sans ressaut.
// Une jupe cylindrique s'arrêtait net sur l'épaule ; en la faisant
// simplement descendre, elle finissait en lame de couteau.
pente    = (body_r - flute_d - neck_r) / max(shoulder_h, 0.01);
// La jupe descend sur TOUTE l'épaule : sinon il reste une bande nue
// entre le haut des tuyaux du fût et le bas du bouchon, et c'est par
// là que tout repart. Elle s'évase d'abord le long du congé, puis
// descend droit au diamètre du fût.
ext1     = pente > 0
           ? max(min((body_r - flute_d - lid_out_r) / pente, shoulder_h), 0)
           : 0;
ext      = shoulder_h;
ext2     = ext - ext1;
// dessus du bouchon : plein, ou deux peaux avec des poches d'air
lid_ceil = (iso && iso_lid) ? lid_top + iso_gap + iso_wall : lid_top;
lid_h    = neck_h + lid_extra + lid_ceil + ext;

// porte-étiquette
lab_x   = body_r - label_flat;          // plan du méplat
lab_ext = label_card + 0.5 + label_front;
lab_hz  = label_h + label_rail;         // hauteur du cadre

// contenance approchée, en millilitres
capacite = PI * pow(use_r, 2) * (z_col - floor_t) / 1000;

// ------------------------------------------------------------
// Porte-étiquette
// ------------------------------------------------------------
module meplat() {
    // Rabote une corde du fût pour que le cadre pose à plat — mais
    // seulement sur la bande du cadre : sur toute la hauteur, il
    // hacherait les cannelures d'un bout à l'autre du pot.
    m = 3;
    if (label)
        translate([lab_x, -(label_w / 2 + label_rail + m), label_z - m])
            cube([body_r + 2, label_w + 2 * label_rail + 2 * m,
                  lab_hz + 2 * m]);
}
module cadre_etiquette() {
    if (label)
        translate([lab_x, -(label_w / 2 + label_rail), label_z])
            cube([lab_ext, label_w + 2 * label_rail, lab_hz]);
}
module fente_etiquette() {
    if (label) {
        // fente : ouverte en haut, on y glisse la languette
        translate([lab_x - 0.6, -(label_w + 0.5) / 2, label_z + label_rail])
            cube([label_card + 0.5 + 0.6, label_w + 0.5, lab_hz + 2]);
        // fenêtre : le pont du haut se fait sans support
        translate([lab_x + label_card + 0.4,
                   -(label_w / 2 - label_rail), label_z + 2 * label_rail])
            cube([lab_ext, label_w - 2 * label_rail,
                  label_h - 2 * label_rail]);
    }
}
// La languette, à imprimer à plat et à écrire dessus
module languette() {
    linear_extrude(height = label_card)
        offset(r = 1.5, $fn = 24) offset(delta = -1.5)
            square([label_w, label_h + label_rail], center = true);
}

// ------------------------------------------------------------
// Corps
// ------------------------------------------------------------
module corps() {
    difference() {
        union() {
            difference() {
                corps_brut();
                meplat();
            }
            cadre_etiquette();
        }
        fente_etiquette();
    }
}

module corps_brut() {
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
            cylinder(r = use_r, h = z_ep - floor_t + 0.01);
            translate([0, 0, z_ep - floor_t])
                cylinder(r1 = use_r, r2 = neck_in, h = shoulder_h);
            translate([0, 0, z_col - floor_t])
                cylinder(r = neck_in, h = neck_h + 1);
        }
        // isolation : une couronne de tuyaux verticaux, ou à défaut une
        // lame continue. Refermée en haut par l'épaule, posée en bas
        // sur une assise pleine.
        if (iso) {
            hi = z_ep - floor_t - iso_base;
            if (iso_n > 0)
                for (i = [0 : iso_n - 1])
                    rotate([0, 0, i * 360 / iso_n])
                        translate([in_r - iso_gap / 2, 0, floor_t + iso_base])
                            cylinder(d = iso_gap, h = hi, $fn = 20);
            else
                translate([0, 0, floor_t + iso_base])
                    difference() {
                        cylinder(r = in_r, h = hi);
                        translate([0, 0, -1])
                            cylinder(r = use_r + iso_wall, h = hi + 2);
                    }
        }
    }
}

// ------------------------------------------------------------
// Couvercle — imprimé à l'endroit, dessus sur le plateau
// ------------------------------------------------------------
module couvercle() {
    difference() {
        union() {
            cylinder(r = lid_out_r, h = lid_h - ext);
            // évasement le long du congé, puis descente droite au ras
            // du fût jusqu'à la base de l'épaule
            if (ext1 > 0)
                translate([0, 0, lid_h - ext])
                    cylinder(r1 = lid_out_r, r2 = body_r - flute_d, h = ext1);
            if (ext2 > 0)
                translate([0, 0, lid_h - ext2])
                    cylinder(r = body_r - flute_d, h = ext2);
            // stries de préhension
            if (knurl > 0)
                for (i = [0 : knurl - 1])
                    rotate([0, 0, i * 360 / knurl])
                        translate([lid_out_r, 0, 0])
                            cylinder(r = knurl_d, h = lid_h, $fn = 12);
        }
        // alésage
        translate([0, 0, lid_ceil])
            cylinder(r = lid_in_r + thread_depth, h = lid_h);
        // le filet est ajouté en NÉGATIF : on retire la gorge dans
        // laquelle viendra le filet du col
        translate([0, 0, lid_ceil + 0.4])
            filet(lid_in_r - 0.2, thread_depth + 0.2, thread_lead,
                  tours + 0.5, thread_starts, thread_clear);
        // le col ne doit pas toucher le plafond
        translate([0, 0, lid_ceil])
            cylinder(r = lid_in_r, h = lid_h);
        // dégagement de l'épaule sous le filetage : la jupe l'enjambe
        // sans la toucher, en gardant le même jeu que le filet
        if (ext > 0)
            translate([0, 0, lid_ceil + neck_h + lid_extra])
                cylinder(r1 = lid_in_r, r2 = lid_in_r + ext * pente,
                         h = ext + 0.1);
        // tuyaux de la jupe : mêmes puits verticaux que dans le fût,
        // logés dans l'épaisseur ajoutée. Fermés en haut par le
        // plafond, en bas par un bourrelet plein.
        if (iso && iso_skirt)
            for (i = [0 : lid_tube_n - 1])
                rotate([0, 0, i * 360 / lid_tube_n])
                    translate([lid_tube_r, 0, lid_ceil + 1])
                        cylinder(d = iso_gap,
                                 h = lid_h - ext - lid_ceil - 2, $fn = 16);
        // poches d'air du dessus, en nid d'abeilles entre les deux
        // peaux. Le bouchon s'imprime dessus en bas : chaque poche est
        // un petit puits, refermé par un pont de sa seule largeur.
        if (iso && iso_lid) {
            pas = iso_gap + 1.6;
            nn  = ceil(lid_in_r / pas) + 1;
            for (i = [-nn : nn], j = [-nn : nn]) {
                px = i * pas + (j % 2 == 0 ? 0 : pas / 2);
                py = j * pas * 0.866;
                if (sqrt(px * px + py * py) < lid_in_r - iso_gap / 2 - 1.2)
                    translate([px, py, lid_top])
                        cylinder(d = iso_gap, h = iso_gap, $fn = 16);
            }
        }
    }
}

// ------------------------------------------------------------
// Sortie
// ------------------------------------------------------------
if (part == "body") corps();
if (part == "lid")  couvercle();
if (part == "tag")  languette();
if (part == "both") {
    corps();
    translate([body_d + 12, 0, 0]) couvercle();
}
echo(str("Contenance ~ ", round(capacite), " ml ; hauteur totale ",
         h_tot, " mm", iso ? str(" ; double paroi, utile Ø",
         round(2 * use_r * 10) / 10) : ""));
