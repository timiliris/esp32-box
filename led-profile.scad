// ============================================================
//  LED Profile Builder — diffuseurs à clipser, profil orienté
//  part = "seg" | "diff" | "both"
// ============================================================
// Le profil se visse sur un support (mur, sous-nez de marche, plafond).
// Le canal qui porte le ruban est INCLINÉ par rapport à ce support :
// c'est ce qui envoie la lumière où l'on veut. Une visière prolonge la
// joue côté œil pour qu'on ne voie jamais les LED en face.

part = "both";

// --- Ruban et canal ----------------------------------------
strip_w = 10;    // largeur du ruban LED
chan_d  = 12;    // profondeur du canal, du ruban à la bouche
wall_t  = 2;     // épaisseur de matière
angle   = 78;    // inclinaison du canal, en degrés depuis la normale
                 // au support. 0 = plein axe, 90 = rasant.
visor   = 10;    // rallonge de la joue côté œil, contre l'éblouissement

// --- Diffuseur ---------------------------------------------
diff_t    = 1.6; // épaisseur du diffuseur
diff_grip = 1.2; // profondeur des rainures qui le retiennent
diff_clr  = 0.25;// jeu de glissement

// --- Platine de fixation -----------------------------------
plate_h  = 26;   // hauteur de la platine contre le support
plate_t  = 3;    // son épaisseur
screw_d  = 3.4;  // Ø de perçage
screw_n  = 2;    // vis par segment ; 0 = aucune (collage)

// --- Segment et raccord ------------------------------------
seg_len  = 200;  // longueur d'un segment
join_len = 8;    // longueur du tenon de raccord
join_clr = 0.25; // jeu du raccord
// Pas de percage pour le fil : il court DANS le canal, le long du
// ruban, comme dans un profilé alu. Un trou traversant coupait la
// jonction entre le canal et la platine et détachait l'un de l'autre.

$fn = 48;

// ------------------------------------------------------------
// Section du canal, dans son repère propre
//   u = en travers du ruban, v = vers la bouche
// ------------------------------------------------------------
module canal_2d(sw, wt, cd, dt, grip, clr, vis) {
    hu = sw / 2 + wt;          // demi-largeur extérieure
    hv = wt + cd;              // hauteur de la bouche
    difference() {
        union() {
            translate([-hu, 0]) square([2 * hu, hv]);
            // visière : la joue du côté +u monte plus haut
            if (vis > 0)
                translate([sw / 2, 0]) square([wt, hv + vis]);
        }
        // logement du ruban et couloir de lumière
        translate([-sw / 2, wt]) square([sw, cd + vis + 2]);
        // rainures du diffuseur, juste sous la bouche
        for (s = [-1, 1])
            translate([s * (sw / 2 + clr) - (s > 0 ? 0 : grip),
                       hv - dt - clr - grip])
                square([grip, dt + 2 * clr]);
    }
}

// Le diffuseur : une lame qui coulisse dans les rainures
module diffuseur_2d(sw, grip, clr, dt) {
    translate([-(sw / 2 + grip - clr), 0])
        square([sw + 2 * (grip - clr), dt]);
}

// ------------------------------------------------------------
// Section complète : platine + canal incliné
// ------------------------------------------------------------
// Le canal est dessiné bouche vers +y. Pour que `angle` se lise comme
// on l'attend — 0 = plein axe, 90 = rasant le support — il faut donc le
// basculer de angle-90, et non de -angle.
th   = angle - 90;
hu_  = strip_w / 2 + wall_t;
hv_  = wall_t + chan_d + visor;
// abscisse la plus rentrante du canal une fois tourné : on s'en sert
// pour l'enfoncer juste ce qu'il faut dans la platine
coins = [[-hu_, 0], [hu_, 0], [hu_, hv_], [-hu_, wall_t + chan_d]];
minx  = min([for (p = coins) p[0] * cos(th) - p[1] * sin(th)]);
dx    = plate_t - minx - wall_t;   // recouvrement franc, pas un contact

module section_2d() {
    union() {
        // platine contre le support, dans le plan x = 0..plate_t
        translate([0, -plate_h / 2]) square([plate_t, plate_h]);
        translate([dx, 0])
            rotate([0, 0, th])
                canal_2d(strip_w, wall_t, chan_d, diff_t, diff_grip,
                         diff_clr, visor);
    }
}

// ------------------------------------------------------------
// Raccord : tenon dans la PLATINE, la seule partie assez épaisse.
// Un décalage négatif de toute la section effaçait les joues de 2 mm
// et sortait en pièce détachée — d'où un tenon dessiné, pas déduit.
// ------------------------------------------------------------
join_w = max(min(plate_h - 6, 14), 5);   // largeur du tenon

module tenon_2d(jeu = 0) {
    offset(delta = -jeu)
        translate([0.6, -join_w / 2]) square([plate_t - 1.2, join_w]);
}
// cran d'encliquetage : un bourrelet en travers du tenon
module cran(z, jeu = 0) {
    translate([plate_t - 0.6, 0, z])
        rotate([90, 0, 0])
            cylinder(r = 0.5 + jeu, h = join_w + 2, center = true, $fn = 16);
}

// ------------------------------------------------------------
// Segment
// ------------------------------------------------------------
module segment() {
    difference() {
        union() {
            linear_extrude(height = seg_len) section_2d();
            // tenon mâle, à un bout
            translate([0, 0, seg_len])
                linear_extrude(height = join_len) tenon_2d(join_clr);
            cran(seg_len + join_len / 2);
        }
        // mortaise femelle, à l'autre bout
        translate([0, 0, -0.01])
            linear_extrude(height = join_len + 0.02) tenon_2d();
        cran(join_len / 2, join_clr);
        // perçages de fixation
        if (screw_n > 0)
            for (i = [0 : screw_n - 1])
                translate([-1, 0, seg_len * (i + 0.5) / screw_n])
                    rotate([0, 90, 0]) cylinder(d = screw_d, h = plate_t + 2);
    }
}

// ------------------------------------------------------------
// Sortie
// ------------------------------------------------------------
if (part == "seg")  segment();
if (part == "diff")
    linear_extrude(height = seg_len)
        diffuseur_2d(strip_w, diff_grip, diff_clr, diff_t);
if (part == "both") {
    segment();
    translate([plate_t + chan_d + 20, 0, 0])
        linear_extrude(height = seg_len)
            diffuseur_2d(strip_w, diff_grip, diff_clr, diff_t);
}
