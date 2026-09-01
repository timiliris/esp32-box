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
head    = 2;     // garde entre le haut du ruban et le diffuseur

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
rise  = strip_w * sin(angle);               // dénivelé du ruban
bw    = wi + 2 * wall_t;                    // largeur hors tout
h_dif = base_t + rise + head;               // dessous du diffuseur
h_lo  = h_dif + diff_t;                     // joue côté mur
h_hi  = h_lo + visor;                       // joue côté volée : la visière

// ------------------------------------------------------------
// Section
// ------------------------------------------------------------
module section_2d() {
    difference() {
        union() {
            square([bw, h_lo]);                              // canal
            translate([bw - wall_t, 0]) square([wall_t, h_hi]); // visière
        }
        // creux : tout ce qui est au-dessus du plan incliné du ruban
        translate([wall_t, base_t])
            polygon([[0, 0], [wi, rise], [wi, h_hi], [0, h_hi]]);
        // rainures du diffuseur, dans les deux joues
        translate([wall_t - diff_grip, h_dif - diff_clr])
            square([diff_grip + 0.01, diff_t + 2 * diff_clr]);
        translate([bw - wall_t - 0.01, h_dif - diff_clr])
            square([diff_grip + 0.01, diff_t + 2 * diff_clr]);
    }
}

module diffuseur_2d() {
    translate([wall_t - diff_grip + diff_clr, 0])
        square([wi + 2 * (diff_grip - diff_clr), diff_t]);
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
echo(str("largeur ", bw, " mm, hauteur ", h_hi, " mm"));
