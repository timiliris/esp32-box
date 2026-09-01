// ============================================================
//  LED Profile Builder — canal simple, ruban incliné dedans
//  part = "seg" | "diff" | "both"
// ============================================================
// Un canal à FOND PLAT, qu'on colle sur une bordure : toute la semelle
// porte, rien ne bascule. C'est le RUBAN qui est incliné à l'intérieur,
// sur un plan en pente, et la joue haute lui sert de visière.
// Le mur est du côté -x, la volée du côté +x.

part = "both";

// --- Ruban --------------------------------------------------
strip_w = 10;    // largeur du ruban LED
angle   = 45;    // inclinaison du ruban : 0 = à plat, il éclaire droit
                 // vers le haut ; plus on monte, plus il vise le mur
strip_clr = 0.6; // jeu de pose du ruban dans le canal

// --- Profil -------------------------------------------------
wall_t  = 1.6;   // épaisseur des joues
base_t  = 1.6;   // épaisseur de la semelle
visor   = 6;     // ce dont la joue haute dépasse du diffuseur
head    = 3;     // écart ruban -> diffuseur, mesuré PERPENDICULAIREMENT
                 // au ruban : le diffuseur lui est parallèle, donc cet
                 // écart est le même sur toute la largeur

// --- Diffuseur ----------------------------------------------
diff_t    = 1.6; // épaisseur
diff_grip = 1.0; // profondeur des rainures
diff_clr  = 0.25;// jeu de glissement

// --- Segment et raccord -------------------------------------
seg_len  = 200;  // longueur d'un segment
join_len = 8;    // longueur du tenon ; 0 = bout à bout
join_clr = 0.25; // jeu du raccord

$fn = 32;

// ------------------------------------------------------------
// Cotes dérivées
// ------------------------------------------------------------
wi    = strip_w * cos(angle) + strip_clr;   // largeur intérieure
rise  = wi * tan(angle);                    // dénivelé de la rampe
bw    = wi + 2 * wall_t;                    // largeur hors tout
// repère de la rampe : d le long, n perpendiculaire (vers le haut)
dvec  = [cos(angle), sin(angle)];
nvec  = [-sin(angle), cos(angle)];
P0    = [wall_t, base_t];                   // bas de rampe, côté mur
P1    = [wall_t + wi, base_t + rise];       // haut de rampe, côté volée
// sommets des deux joues, pris sur le plan du diffuseur
L     = P0 + nvec * (head + diff_t);        // joue côté mur
R     = P1 + nvec * (head + diff_t + visor);// joue côté volée : la visière
h_hi  = R[1];                               // hauteur hors tout
h_lo  = L[1];

// ------------------------------------------------------------
// Section
// ------------------------------------------------------------
// Contour : semelle plate, joue basse côté mur, visière côté volée, et
// entre les deux la rampe du ruban. Huit points, rien de plus.
module section_2d() {
    difference() {
        polygon([[0, 0], [bw, 0], [bw, R[1]], [bw - wall_t, R[1]],
                 P1, P0, [wall_t, L[1]], [0, L[1]]]);
        // rainures : le logement du diffuseur, parallèle à la rampe et
        // débordant dans les deux joues
        e0 = P0 - dvec * diff_grip + nvec * (head - diff_clr);
        e1 = P1 + dvec * diff_grip + nvec * (head - diff_clr);
        ep = nvec * (diff_t + 2 * diff_clr);
        polygon([e0, e1, e1 + ep, e0 + ep]);
    }
}

// Le diffuseur : une lame plate, imprimée à plat, qui coulisse dans les
// rainures. Sa longueur suit la rampe, pas la largeur du canal.
module diffuseur_2d() {
    square([wi / cos(angle) + 2 * (diff_grip - diff_clr), diff_t]);
}

// ------------------------------------------------------------
// Raccord : tenon dans la semelle, la seule partie pleine
// ------------------------------------------------------------
join_w = max(min(wi - 2, 14), 4);

module tenon_2d(jeu = 0) {
    offset(delta = -jeu)
        translate([bw / 2 - join_w / 2, 0.4]) square([join_w, base_t - 0.8]);
}
module cran(z, jeu = 0) {
    translate([bw / 2, base_t - 0.4, z])
        rotate([0, 90, 0])
            cylinder(r = 0.4 + jeu, h = join_w + 2, center = true, $fn = 12);
}

// ------------------------------------------------------------
// Segment
// ------------------------------------------------------------
module segment() {
    difference() {
        union() {
            linear_extrude(height = seg_len) section_2d();
            if (join_len > 0) {
                translate([0, 0, seg_len])
                    linear_extrude(height = join_len) tenon_2d(join_clr);
                cran(seg_len + join_len / 2);
            }
        }
        if (join_len > 0) {
            translate([0, 0, -0.01])
                linear_extrude(height = join_len + 0.02) tenon_2d();
            cran(join_len / 2, join_clr);
        }
    }
}

// ------------------------------------------------------------
// Sortie
// ------------------------------------------------------------
if (part == "seg")  segment();
if (part == "diff") linear_extrude(height = seg_len) diffuseur_2d();
if (part == "both") {
    segment();
    translate([bw + 8, 0, 0]) linear_extrude(height = seg_len) diffuseur_2d();
}
echo(str("largeur ", bw, " mm, hauteur ", h_hi,
         " mm, diffuseur ", wi / cos(angle) + 2 * (diff_grip - diff_clr)));
