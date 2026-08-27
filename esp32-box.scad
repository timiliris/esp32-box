// ============================================================
//  ESP32 BOX v2 — boîtier universel paramétrique
//  Coque extérieure continue : gros rayons d'angle, arêtes
//  supérieures en congé, couvercle affleurant clipsé (aucune
//  vis visible) — option vis M3 si besoin de sécuriser.
//  Déclinable S / M / L / XL / custom. Impression sans supports.
// ============================================================

/* [Pièce à générer] */
// base, lid, both (côte à côte), assembled (vue fermée),
// inserts (fenêtres clipsables à imprimer en PETG transparent/blanc)
part = "both"; // [base, lid, both, assembled, inserts]

/* [Taille] */
// Préréglages (dimensions INTÉRIEURES) ou "custom"
size_preset = "M"; // [S, M, L, XL, custom]
// Dimensions intérieures si size_preset = custom [largeur, profondeur, hauteur]
custom_inner = [100, 70, 40];

/* [Fermeture du couvercle] */
// snap = clipsé invisible, screws = 4 vis M3 fraisées sur le dessus
lid_fix = "snap"; // [snap, screws]

/* [Coque] */
wall = 2.4;          // épaisseur des parois
floor_t = 2.0;       // épaisseur du fond
lid_t = 3.0;         // épaisseur du couvercle
corner_r = 9;        // rayon des coins
edge_r = 2.5;        // congé des arêtes supérieures
bottom_ch = 0.8;     // chanfrein du bas
lid_clearance = 0.25; // jeu du couvercle (à ajuster selon l'imprimante)
lip_h = 7;           // hauteur de la jupe du couvercle
lip_t = 1.8;         // épaisseur de la jupe (fine = elle flexe pour clipser)

/* [Aérations] */
vents = true;
vent_w = 1.8;        // largeur d'une fente
vent_pitch = 4.5;    // espacement des fentes
vent_frac = 0.38;    // hauteur des fentes (fraction de la hauteur int.)

/* [Découpe USB (face avant)] */
usb_cutout = true;
usb_w = 13;          // largeur de l'ouverture
usb_h = 8;           // hauteur de l'ouverture
usb_z = 5;           // hauteur du bas de l'ouverture (depuis le fond int.)
usb_x = 0;           // décalage horizontal depuis le centre

/* [Fenêtre radar mmWave (paroi avant, pour LD2410B)] */
radar_window = false;
radar_w = 30;        // largeur de la fenêtre
radar_h = 14;        // hauteur de la fenêtre
radar_thin = 1.0;    // épaisseur de plastique restante devant le radar
radar_x = 0;         // décalage horizontal depuis le centre
radar_z = 18;        // hauteur du centre (depuis le fond int.)

/* [Port USB-C (module de charge)] */
side_usbc = false;
side_usbc_face = "back"; // [back, front, left, right]
side_usbc_w = 10;    // largeur de l'ouverture
side_usbc_h = 6;     // hauteur de l'ouverture
side_usbc_off = -20; // décalage le long de la paroi depuis le centre
side_usbc_z = 10;    // hauteur du centre (depuis le fond int.)

/* [Sortie audio (jack 3.5 mm)] */
audio_hole = false;
audio_face = "back"; // [back, front, left, right]
audio_d = 6.5;       // diamètre (jack châssis 3.5 mm)
audio_off = 20;      // décalage le long de la paroi depuis le centre
audio_z = 10;        // hauteur du centre (depuis le fond int.)

/* [Bouton poussoir] */
button_hole = false;
button_face = "front"; // [back, front, left, right]
button_d = 7.2;      // Ø perçage (7 mm = poussoir type PBS-110 ; 12.2 pour un 12 mm)
button_off = 42;     // décalage le long de la paroi depuis le centre
button_z = 10;       // hauteur du centre (depuis le fond int.)

/* [Découpes libres (générées par le builder)] */
// Liste de [face, type, off, z, a, b, peau] :
//   face : "front" / "back" / "left" / "right" / "lid" / "floor"
//   type : "rect" (a=largeur, b=hauteur), "circle" (a=diamètre),
//          "window" (comme rect mais borgne, laisse `peau` mm dehors),
//          "insert" (trou traversant à feuillure + fenêtre clipsable
//          séparée, générée par part="inserts"),
//          aérations : "vslots" (fentes verticales), "hslots"
//          (fentes horizontales), "grid" (trous Ø3 en quinconce),
//          "hex" (nid d'abeille) — a×b = zone remplie par le motif ;
//          boutons pour tact switch 6x6 (parois uniquement, a = Ø
//          capuchon) : "btnflex" (languette imprimée en place) et
//          "btnpiston" (piston coulissant, capuchon généré avec
//          part="inserts") — berceau 6x6 intégré côté intérieur
//   off  : décalage le long de la paroi depuis le centre (vu de l'extérieur)
//   z    : hauteur du centre depuis le fond intérieur ;
//          pour lid/floor, off = X et z = Y depuis le centre (vue de dessus)
cuts = [];

/* [Fixation murale] */
// Pattes d'œillet au niveau du fond, imprimées avec la base
mount_tabs = "none"; // [none, x, y]  x = flancs, y = avant/arrière
mount_n = 2;         // [2, 4]
mount_hole = 4.2;    // Ø du trou de vis
// Groupes d'entretoises PCB :
// [cx, cy, entraxe_x, entraxe_y, h, dia, avant-trou, deux_trous, couvercle]
// deux_trous : 0 = 4 plots en rectangle, 1 = 2 plots seulement, aux
// positions (±x/2, ±y/2) liées — paire alignée ou diagonale
// couvercle : 1 = plots suspendus sous le couvercle (écran, carte
// vissée contre la face intérieure du couvercle) au lieu du fond
standoff_sets = [];
// Socles de cellule cylindrique (18650…) : [cx, cy, rot, longueur, dia]
// rot : 0 = axe le long de X, 90 = le long de Y
cell_holders = [];
// Cloisons internes (isolation de capteurs) :
// [cx, cy, rot, longueur, hauteur, épaisseur, passage_l, passage_off, aérée]
// rot : 0 = le long de X, 90 = le long de Y ; hauteur 0 = pleine
// (jusqu'au couvercle) ; passage_l = largeur de l'encoche à câble en
// haut (0 = aucune), passage_off = son décalage le long de la cloison ;
// aérée = 1 : créneaux automatiques en bas (ras du fond) et en haut
// (sous le couvercle) pour la convection, la cloison garde des pieds.
// Les cloisons sont rognées au volume intérieur : fais-les dépasser
// pour qu'elles se raccordent proprement aux parois.
dividers = [];
// Compartiments fermés (isolation de capteur avec air extérieur) :
// [cx, cy, largeur, profondeur, aération_fond, aération_couvercle,
//  côté_passage, largeur_passage, aération_parois]
// aération_parois = 1 : les sections de parois de la boîte en contact
// avec le compartiment reçoivent aussi un nid d'abeille.
// Cadre pleine hauteur (murs 1.8) autour de la zone intérieure w×d,
// rogné aux parois de la boîte (place-le contre un mur ou un coin).
// aération_fond / _couvercle = 1 : nid d'abeille découpé dans le fond
// sous la zone et/ou dans le couvercle au-dessus -> l'air extérieur
// traverse en cheminée, le capteur respire dehors.
// côté_passage : -1 = aucun, 0 = avant, 1 = arrière, 2 = gauche,
// 3 = droite (encoche à câble en haut du mur choisi).
compartments = [];

/* [Passe-câble (face arrière)] */
cable_hole = false;
cable_d = 12.5;      // 12.5 = presse-étoupe PG7
cable_z = 12;        // hauteur du centre (depuis le fond int.)

/* [Entretoises carte (ESP32 dev board)] */
standoffs = true;
hole_x = 44.5;       // entraxe X des trous de la carte
hole_y = 20.5;       // entraxe Y des trous de la carte
standoff_h = 5;      // hauteur des entretoises
standoff_d = 6.5;    // diamètre des entretoises
standoff_pilot = 2.2; // avant-trou (vis M2.5 autoformeuse)
board_off = [0, 0];  // décalage de la carte depuis le centre

/* [Fentes zip-tie au fond] */
tie_slots = true;

/* [Clips (mode snap)] */
// x = clips sur les flancs, y = clips avant/arrière — à mettre sur
// des faces SANS connecteur pour déclipser sans gêner les câbles
snap_sides = "x"; // [x, y]
notch_sides = "x"; // [x, y, none]
snap_len = 18;       // longueur des bossages de clip
snap_r = 0.8;        // saillie des bossages
groove_r = 1.0;      // profondeur des rainures en face

/* [Fenêtre LED (face arrière, lueur vers le mur)] */
led_window = false;
led_w = 74;          // largeur de la fenêtre (bande 70 mm + marge)
led_h = 12;          // hauteur de la fenêtre
led_x = 0;           // décalage horizontal depuis le centre
led_z = 30;          // hauteur du centre (depuis le fond int.)
led_thin = 1.0;      // peau restante (diffuseur) ; 0 = traversant

/* [Vis (mode screws)] */
post_d = 7;          // diamètre des colonnes de vissage
screw_pilot = 2.7;   // avant-trou M3 autoformeuse
screw_hole = 3.4;    // passage de vis dans le couvercle
cs_d = 6.6;          // diamètre de la tête fraisée

/* [Impression 3D] */
// Élargissement des trous/découpes fonctionnels : le FDM rétrécit
// les ouvertures d'environ 0.2 à 0.4 mm
hole_comp = 0.3;
// Trous ronds des parois en goutte d'eau (sommet à 45°) :
// s'impriment sans support et sans affaissement
teardrop = true;

/* [Qualité] */
$fn = 48;

// ------------------------------------------------------------
// Dimensions
// ------------------------------------------------------------
function inner_dims() =
    size_preset == "S"  ? [ 70,  50, 30] :
    size_preset == "M"  ? [100,  70, 40] :
    size_preset == "L"  ? [140, 100, 50] :
    size_preset == "XL" ? [180, 130, 60] :
    custom_inner;

iw = inner_dims()[0];
id = inner_dims()[1];
ih = inner_dims()[2];

ow = iw + 2 * wall;
od = id + 2 * wall;
H = floor_t + ih + lid_t;    // hauteur totale boîte fermée
seam = floor_t + ih;         // altitude du joint base / couvercle
inner_r = max(corner_r - wall, 1);

lip_w = iw - 2 * lid_clearance;
lip_d = id - 2 * lid_clearance;
snap_z = seam - 3.5;         // altitude des clips

// Colonnes de vissage — enfoncées de 0.8 mm dans les parois
post_x = iw / 2 - post_d / 2 + 0.8;
post_y = id / 2 - post_d / 2 + 0.8;

// ------------------------------------------------------------
// Primitives
// ------------------------------------------------------------
module rrect(w, d, r) {
    offset(r) offset(-r) square([w, d], center = true);
}

module rbox(w, d, h, r) {
    linear_extrude(height = h) rrect(w, d, r);
}

// Profil goutte d'eau : cercle + toit à 45°, pointe vers +y
module teardrop2d(d) {
    r = d / 2;
    circle(r = r);
    polygon([[-r / sqrt(2), r / sqrt(2)], [0, r * sqrt(2)],
             [r / sqrt(2), r / sqrt(2)]]);
}

// Pré-rotation pour que la pointe de la goutte vise +Z global
// une fois passée dans on_wall()
function droop_rot(face) =
    face == "back" ? 180 : face == "right" ? 90 :
    face == "left" ? -90 : 0;

// Perçage rond au travers d'une paroi, compensé impression
// (goutte d'eau si teardrop, cercle sinon)
module wall_drill(face, off, zc, d) {
    on_wall(face, off, zc)
        rotate([0, 0, droop_rot(face)])
            linear_extrude(height = wall + 2, center = true) {
                // sous 5 mm un trou rond s'imprime bien sans goutte d'eau
                if (teardrop && d + hole_comp >= 5) teardrop2d(d + hole_comp);
                else circle(d = d + hole_comp);
            }
}

// Capsule horizontale le long de X (pour clips et rainures)
module xcapsule(len, r) {
    hull()
        for (s = [-1, 1])
            translate([s * (len / 2 - r), 0, 0])
                sphere(r = r, $fn = 32);
}

// Colonne d'angle : chanfrein bas, fût, congé haut
module corner_column() {
    cylinder(r1 = corner_r - bottom_ch, r2 = corner_r, h = bottom_ch);
    translate([0, 0, bottom_ch])
        cylinder(r = corner_r, h = H - bottom_ch - edge_r);
    translate([0, 0, H - edge_r]) {
        rotate_extrude()
            translate([corner_r - edge_r, 0])
                circle(r = edge_r);
        cylinder(r = corner_r - edge_r, h = edge_r);
    }
}

// Coque extérieure pleine, forme continue de la boîte fermée
module shell_solid() {
    hull()
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx * (ow / 2 - corner_r), sy * (od / 2 - corner_r), 0])
                corner_column();
}

// Tranche de la coque entre deux altitudes
module shell_slice(z0, z1) {
    intersection() {
        shell_solid();
        translate([-ow, -od, z0])
            cube([2 * ow, 2 * od, z1 - z0]);
    }
}

// ------------------------------------------------------------
// Détails de la base
// ------------------------------------------------------------
module screw_posts() {
    for (sx = [-1, 1], sy = [-1, 1])
        translate([sx * post_x, sy * post_y, floor_t])
            cylinder(d = post_d, h = ih);
}

module screw_pilots() {
    depth = min(12, ih - 4);
    for (sx = [-1, 1], sy = [-1, 1])
        translate([sx * post_x, sy * post_y, seam - depth])
            cylinder(d = screw_pilot, h = depth + 1);
}

// Rainures des clips, creusées dans les parois choisies
module snap_grooves() {
    if (snap_sides == "y")
        for (sy = [-1, 1])
            translate([0, sy * id / 2, snap_z])
                xcapsule(snap_len + 2, groove_r);
    else
        for (sx = [-1, 1])
            translate([sx * iw / 2, 0, snap_z])
                rotate([0, 0, 90])
                    xcapsule(snap_len + 2, groove_r);
}

module vent_cuts() {
    usable = id - 2 * (corner_r + 6);
    n = max(floor(usable / vent_pitch), 3);
    h = max(ih * vent_frac, 8);
    zc = floor_t + h / 2 + 4;   // bande basse, discrète
    for (side = [-1, 1])
        for (i = [0 : n - 1])
            translate([side * (iw / 2 + wall / 2),
                       (i - (n - 1) / 2) * vent_pitch, zc])
                hull()
                    for (z = [-1, 1])
                        translate([0, 0, z * (h / 2 - vent_w / 2)])
                            rotate([0, 90, 0])
                                cylinder(d = vent_w, h = wall + 2,
                                         center = true);
}

module usb_cut() {
    translate([usb_x, -(id / 2 + wall / 2), floor_t + usb_z + usb_h / 2])
        rotate([90, 0, 0])
            linear_extrude(height = wall + 2, center = true)
                rrect(usb_w + hole_comp, usb_h + hole_comp, 2);
}

// Évidement borgne dans la paroi avant : laisse une peau fine
// (radar_thin) devant le LD2410B — le mmWave traverse le plastique.
module radar_pocket() {
    pocket = wall - radar_thin;
    translate([radar_x, -(id / 2 + pocket / 2), floor_t + radar_z])
        rotate([90, 0, 0])
            linear_extrude(height = pocket + 0.01, center = true)
                rrect(radar_w, radar_h, 2);
}

module cable_cut() {
    wall_drill("back", 0, cable_z, cable_d);
}

// Positionne un enfant (extrudé le long de son z local) au travers
// de la paroi choisie, à `off` du centre et `zc` du fond intérieur.
// `inset` recule le centre vers l'intérieur (poches borgnes).
module on_wall(face, off, zc, inset = 0) {
    if (face == "back")
        translate([off, id / 2 + wall / 2 - inset, floor_t + zc])
            rotate([-90, 0, 0]) children();
    if (face == "front")
        translate([off, -(id / 2 + wall / 2 - inset), floor_t + zc])
            rotate([90, 0, 0]) children();
    if (face == "right")
        translate([iw / 2 + wall / 2 - inset, off, floor_t + zc])
            rotate([0, 90, 0]) children();
    if (face == "left")
        translate([-(iw / 2 + wall / 2 - inset), off, floor_t + zc])
            rotate([0, -90, 0]) children();
}

// Motifs d'aération 2D, centrés, remplissant une zone a × b
function is_vent(t) = t == "vslots" || t == "hslots" || t == "grid" || t == "hex";

module vent_pattern2d(t, a, b) {
    if (t == "vslots") {
        n = max(floor((a - 2) / 4.5) + 1, 1);
        for (i = [0 : n - 1])
            translate([(i - (n - 1) / 2) * 4.5, 0])
                rrect(2, b, 0.9);
    }
    if (t == "hslots") {
        n = max(floor((b - 2) / 4.5) + 1, 1);
        for (j = [0 : n - 1])
            translate([0, (j - (n - 1) / 2) * 4.5])
                rrect(a, 2, 0.9);
    }
    if (t == "grid") {
        ny = max(floor((b - 3) / (5 * 0.866)) + 1, 1);
        nx = max(floor((a - 3) / 5) + 1, 1);
        for (j = [0 : ny - 1], i = [0 : nx - 1]) {
            x = (i - (nx - 1) / 2) * 5 + (j % 2 == 1 ? 2.5 : 0);
            if (abs(x) <= (a - 3) / 2 + 0.01)
                translate([x, (j - (ny - 1) / 2) * 5 * 0.866])
                    circle(d = 3);
        }
    }
    if (t == "hex") {
        r = 5 / sqrt(3);
        ny = max(floor((b - 2 * r) / 5.72) + 1, 1);
        nx = max(floor((a - 5) / 6.6) + 1, 1);
        for (j = [0 : ny - 1], i = [0 : nx - 1]) {
            x = (i - (nx - 1) / 2) * 6.6 + (j % 2 == 1 ? 3.3 : 0);
            if (abs(x) <= (a - 5) / 2 + 0.01)
                translate([x, (j - (ny - 1) / 2) * 5.72])
                    rotate(30) circle(r = r, $fn = 6);
        }
    }
}

// ------------------------------------------------------------
// Boutons pour tact switch 6x6
// ------------------------------------------------------------
function is_btn(t) = t == "btnflex" || t == "btnpiston";

// repère local sur la face INTÉRIEURE d'une paroi :
// x = le long de la paroi, +y = vers l'intérieur, z = vertical
module on_iwall(face, off, zc) {
    if (face == "front")
        translate([off, -id / 2, floor_t + zc]) children();
    if (face == "back")
        translate([off, id / 2, floor_t + zc]) rotate([0, 0, 180]) children();
    if (face == "left")
        translate([-iw / 2, off, floor_t + zc]) rotate([0, 0, -90]) children();
    if (face == "right")
        translate([iw / 2, off, floor_t + zc]) rotate([0, 0, 90]) children();
}

// découpes de la languette : fente en U + charnière amincie en haut
module btnflex_cuts() {
    for (s = [-1, 1])
        translate([s * 7.65, -wall / 2, 0])
            cube([1.3, wall + 2, 17.3], center = true);
    translate([0, -wall / 2, -8.65])
        cube([16.6, wall + 2, 1.3], center = true);
    // amincissement de la charnière : peau extérieure 1.0
    translate([-8.3, -(wall - 1.0), 6.9])
        cube([16.6, wall + 1, 2.3]);
}

// trou de coulissement du piston (goutte d'eau si assez grand)
module btnpiston_cuts(capd) {
    dd = capd - 1.8 + hole_comp;
    translate([0, -wall - 1, 0])
        rotate([-90, 0, 0])
            linear_extrude(height = wall + 2) {
                if (teardrop && dd >= 5) rotate(180) teardrop2d(dd - hole_comp);
                else circle(d = dd);
            }
}

// berceau du tact switch 6x6 : bloc plein chanfreiné à 45° dessous,
// poche du switch ouverte en haut, fenêtre pour le nub.
// front_y = face avant du bloc ; nub affleure à front_y + 0.3
module switch_cradle(front_y, tongue_clear) {
    span = tongue_clear ? 13 : 8.5;
    back = front_y + 4.9 + 1.8;
    difference() {
        translate([-span, 0, -6]) cube([2 * span, back, 13]);
        // poche du corps du switch (6.7, ouverte en haut)
        translate([-3.35, front_y + 1.2, -3.35]) cube([6.7, 3.75, 12]);
        // fenêtre du nub
        translate([-2.75, front_y - 1, -2.75]) cube([5.5, 2.3, 5.5]);
        // languette : aucun contact avec la zone flexible
        if (tongue_clear)
            translate([-9.6, -1, -9]) cube([19.2, 2.6, 18]);
        // piston : logement de la collerette
        if (!tongue_clear)
            translate([0, -1, 0]) rotate([-90, 0, 0]) cylinder(d = 11.6, h = 3.2);
        // chanfrein 45° sous le bloc (impression sans support)
        translate([0, 0, -6]) rotate([45, 0, 0])
            translate([-span - 1, -30, -30]) cube([2 * span + 2, 30, 30]);
    }
}

// Support pour prise USB-C femelle nue (armature seule, à souder) :
// canal derrière la paroi, nez au ras extérieur. L'ouverture (8.7 x
// 2.9) laisse passer la languette du câble mais PAS l'armature
// (8.94 x 3.16) -> brancher pousse la prise contre le fond du canal,
// débrancher la plaque contre la paroi. Insertion par le haut,
// pont de maintien à l'arrière, fils vers le dos.
// L = longueur de l'armature (les variantes courantes font 7.35,
// 10.5, 11.1 ou 12.6 mm — mesure la tienne, le fond de butée doit
// affleurer son dos).
module usbc_cradle(L) {
    difference() {
        translate([-7.2, 0, -4.3]) cube([14.4, L + 1.8, 8.6]);
        // canal de l'armature (9.2 x 3.45 int, centré sur l'ouverture)
        translate([-4.6, -1, -1.72]) cube([9.2, L + 0.4, 3.45]);
        // insertion par le haut (devant le pont arrière)
        translate([-4.6, -1, 0]) cube([9.2, L - 1.6, 8]);
        // passage des fils dans le dos
        translate([-2.75, L - 0.5, -1.2]) cube([5.5, 4, 10]);
        // chanfrein 45° dessous (impression sans support)
        translate([0, 0, -4.3]) rotate([45, 0, 0])
            translate([-8.2, -25, -25]) cube([16.4, 25, 25]);
    }
}

// solides des boutons (ajoutés après la différence de la base)
module buttons_solids() {
    for (c = cuts)
        if ((is_btn(c[1]) || c[1] == "usbc") &&
            (c[0] == "front" || c[0] == "back" ||
             c[0] == "left" || c[0] == "right"))
            on_iwall(c[0], c[2], c[3]) {
                if (c[1] == "usbc")
                    usbc_cradle(len(c) > 6 && c[6] > 0 ? c[6] : 12.6);
                else if (c[1] == "btnflex") {
                    // capuchon extérieur sur la languette
                    translate([0, -wall + 0.01, -1])
                        rotate([90, 0, 0])
                            cylinder(d1 = c[4], d2 = c[4] - 1.3, h = 1.6);
                    // téton presseur intérieur
                    translate([0, -0.01, -1])
                        rotate([-90, 0, 0]) cylinder(d = 4, h = 3);
                    translate([0, 0, -1]) switch_cradle(3.0, true);
                } else {
                    switch_cradle(3.5, false);
                }
            }
}

// piston coulissant, imprimé avec la planche d'inserts (capuchon au plateau)
module piston_plunger(capd) {
    cylinder(d1 = capd, d2 = capd - 1.3, h = 2.2);
    translate([0, 0, 2.1]) cylinder(d = capd - 2.2, h = wall + 0.4);
    translate([0, 0, 2.1 + wall + 0.3]) cylinder(d = capd + 1.4, h = 1.5);
    translate([0, 0, 2.1 + wall + 1.75]) cylinder(d = 4, h = 2);
}

// Découpes libres du builder — parois et fond (appelé dans la base)
module cuts_all() {
    for (c = cuts) {
        f = c[0];
        if (f == "front" || f == "back" || f == "left" || f == "right") {
            horiz = f == "front" || f == "back";
            if (c[1] == "circle")
                wall_drill(f, c[2], c[3], c[4]);
            if (c[1] == "rect")
                on_wall(f, c[2], c[3])
                    linear_extrude(height = wall + 2, center = true)
                        rrect((horiz ? c[4] : c[5]) + hole_comp,
                              (horiz ? c[5] : c[4]) + hole_comp,
                              min(2, min(c[4], c[5]) / 3));
            if (c[1] == "window") {
                skin = len(c) > 6 ? c[6] : 1;
                on_wall(f, c[2], c[3], skin / 2)
                    linear_extrude(height = wall - skin + 0.01, center = true)
                        rrect(horiz ? c[4] : c[5], horiz ? c[5] : c[4],
                              min(3, min(c[4], c[5]) / 3));
            }
            if (is_vent(c[1]))
                on_wall(f, c[2], c[3])
                    rotate([0, 0, droop_rot(f)])
                        linear_extrude(height = wall + 2, center = true)
                            vent_pattern2d(c[1], c[4], c[5]);
            if (c[1] == "btnflex")
                on_iwall(f, c[2], c[3]) btnflex_cuts();
            if (c[1] == "btnpiston")
                on_iwall(f, c[2], c[3]) btnpiston_cuts(c[4]);
            if (c[1] == "usbc")
                on_wall(f, c[2], c[3])
                    linear_extrude(height = wall + 2, center = true)
                        rrect((horiz ? c[4] : c[5]) + hole_comp,
                              (horiz ? c[5] : c[4]) + hole_comp, 1.2);
            if (c[1] == "insert") {
                // trou traversant + feuillure côté extérieur
                on_wall(f, c[2], c[3])
                    linear_extrude(height = wall + 2, center = true)
                        rrect((horiz ? c[4] : c[5]) + hole_comp,
                              (horiz ? c[5] : c[4]) + hole_comp,
                              min(2, min(c[4], c[5]) / 4));
                on_wall(f, c[2], c[3], -(wall / 2 - 0.65))
                    linear_extrude(height = 1.31, center = true)
                        rrect((horiz ? c[4] : c[5]) + 3 + hole_comp,
                              (horiz ? c[5] : c[4]) + 3 + hole_comp, 2.5);
            }
        }
        if (f == "floor") {
            if (c[1] == "circle")
                translate([c[2], c[3], -1])
                    cylinder(d = c[4] + hole_comp, h = floor_t + 2);
            if (c[1] == "rect")
                translate([c[2], c[3], -1])
                    linear_extrude(height = floor_t + 2)
                        rrect(c[4] + hole_comp, c[5] + hole_comp,
                              min(2, min(c[4], c[5]) / 3));
            if (c[1] == "window") {
                skin = len(c) > 6 ? c[6] : 1;
                translate([c[2], c[3], skin])
                    linear_extrude(height = floor_t)
                        rrect(c[4], c[5], min(3, min(c[4], c[5]) / 3));
            }
            if (c[1] == "insert") {
                translate([c[2], c[3], -1])
                    linear_extrude(height = floor_t + 2)
                        rrect(c[4] + hole_comp, c[5] + hole_comp,
                              min(2, min(c[4], c[5]) / 4));
                translate([c[2], c[3], -1])
                    linear_extrude(height = 2.3)
                        rrect(c[4] + 3 + hole_comp, c[5] + 3 + hole_comp, 2.5);
            }
            if (is_vent(c[1]))
                translate([c[2], c[3], -1])
                    linear_extrude(height = floor_t + 2)
                        vent_pattern2d(c[1], c[4], c[5]);
        }
    }
}

// Découpes du couvercle (appelé dans lid_assembled).
// Les découpes de PAROI sont soustraites au couvercle aussi : quand
// un connecteur est haut (carte vissée sous le couvercle), il traverse
// la jupe — celle-ci est entaillée au même endroit. Sans effet si la
// découpe est trop basse pour atteindre la jupe.
module lid_cuts() {
    for (c = cuts)
        if (c[0] == "front" || c[0] == "back" || c[0] == "left" || c[0] == "right") {
            horiz = c[0] == "front" || c[0] == "back";
            a = c[1] == "circle" || is_btn(c[1]) ? c[4] : (horiz ? c[4] : c[5]);
            b = c[1] == "circle" || is_btn(c[1]) ? c[4] : (horiz ? c[5] : c[4]);
            on_wall(c[0], c[2], c[3])
                linear_extrude(height = wall + 6, center = true)
                    rrect(a + hole_comp, b + hole_comp,
                          min(2, min(a, b) / 3));
        }
    for (c = cuts) if (c[0] == "lid") {
        if (c[1] == "circle")
            translate([c[2], c[3], seam - 1])
                cylinder(d = c[4] + hole_comp, h = lid_t + 2);
        if (c[1] == "rect")
            translate([c[2], c[3], seam - 1])
                linear_extrude(height = lid_t + 2)
                    rrect(c[4] + hole_comp, c[5] + hole_comp,
                          min(2, min(c[4], c[5]) / 3));
        if (c[1] == "window") {
            skin = len(c) > 6 ? c[6] : 1;
            translate([c[2], c[3], seam - 1])
                linear_extrude(height = lid_t + 1 - skin)
                    rrect(c[4], c[5], min(3, min(c[4], c[5]) / 3));
        }
        if (c[1] == "insert") {
            translate([c[2], c[3], seam - 1])
                linear_extrude(height = lid_t + 2)
                    rrect(c[4] + hole_comp, c[5] + hole_comp,
                          min(2, min(c[4], c[5]) / 4));
            translate([c[2], c[3], H - 1.3])
                linear_extrude(height = 2.3)
                    rrect(c[4] + 3 + hole_comp, c[5] + 3 + hole_comp, 2.5);
        }
        if (is_vent(c[1]))
            translate([c[2], c[3], seam - 1])
                linear_extrude(height = lid_t + 2)
                    vent_pattern2d(c[1], c[4], c[5]);
    }
    compartment_vents_lid();
    lid_skirt_clearances();
}

// ------------------------------------------------------------
// Inserts de fenêtre : plaque affleurante dans la feuillure,
// corps traversant, deux bossages qui clipsent derrière la paroi.
// À imprimer face extérieure sur le plateau, en PETG transparent
// (guide de lumière / radar) ou blanc (diffuseur).
// ------------------------------------------------------------
// skin = épaisseur de la membrane centrale (0.8 par défaut : les LED
// diffusent bien) ; 0 = cadre ouvert, sans membrane (laser ToF, capteur
// qui doit voir à l'air libre)
module window_insert(a, b, t, skin) {
    r = min(2, min(a, b) / 4);
    difference() {
        union() {
            // plaque de façade (0.4 de jeu total dans la feuillure)
            linear_extrude(height = 1.3)
                rrect(a + 2.6, b + 2.6, 2.3);
            // corps traversant (0.3 de jeu total dans le trou)
            translate([0, 0, 1.2])
                linear_extrude(height = t - 1.2)
                    rrect(a - 0.3, b - 0.3, r);
            // bossages de clip sur les grands côtés
            for (s = [-1, 1])
                translate([0, s * (b - 0.3) / 2, t + 0.2])
                    xcapsule(min(a * 0.5, 24), 0.5);
        }
        // évidement intérieur : membrane fine au centre, pourtour
        // épais (1.6) conservé pour la rigidité et les clips
        translate([0, 0, skin <= 0 ? -1 : skin])
            linear_extrude(height = t + 3)
                rrect(a - 3.5, b - 3.5, max(r - 1, 0.5));
    }
}

function ins_y(list, i) =
    i <= 0 ? 0 : ins_y(list, i - 1) +
        (list[i - 1][1] == "btnpiston" ? list[i - 1][4] + 16
                                       : list[i - 1][5] + 18);

module inserts_plate() {
    ins = [for (c = cuts) if (c[1] == "insert" || c[1] == "btnpiston") c];
    if (len(ins) > 0)
        for (i = [0 : 1 : len(ins) - 1]) {
            t = ins[i][0] == "lid" ? lid_t :
                ins[i][0] == "floor" ? floor_t : wall;
            translate([0, ins_y(ins, i), 0]) {
                if (ins[i][1] == "btnpiston") piston_plunger(ins[i][4]);
                else window_insert(ins[i][4], ins[i][5], t,
                                   len(ins[i]) > 6 ? ins[i][6] : 0.8);
            }
        }
}

// Patte de fixation murale : œillet au ras du sol, s'étend en +X local
module mount_ear() {
    difference() {
        linear_extrude(height = 4)
            hull() {
                translate([10, 0]) circle(r = 7);
                translate([-1, -9]) square([2, 18]);
            }
        translate([10, 0, -1])
            cylinder(d = mount_hole + hole_comp, h = 6);
    }
}

module mount_ears() {
    if (mount_tabs == "x") {
        pos = mount_n >= 4 ? [-(id / 2 - 14), id / 2 - 14] : [0];
        for (sx = [-1, 1], p = pos)
            translate([sx * ow / 2, p, 0])
                rotate([0, 0, sx > 0 ? 0 : 180])
                    mount_ear();
    }
    if (mount_tabs == "y") {
        pos = mount_n >= 4 ? [-(iw / 2 - 14), iw / 2 - 14] : [0];
        for (sy = [-1, 1], p = pos)
            translate([p, sy * od / 2, 0])
                rotate([0, 0, sy > 0 ? 90 : -90])
                    mount_ear();
    }
}

// Groupes d'entretoises PCB du builder
module standoff_post(h, d, p) {
    difference() {
        cylinder(d = d, h = h);
        translate([0, 0, h - 4]) cylinder(d = p, h = 4.5);
    }
}

// Positions d'un groupe : 4 en rectangle, ou 2 à signes liés
function standoff_pos(s) =
    len(s) > 7 && s[7] == 1
        ? [for (sx = [-1, 1]) [s[0] + sx * s[2] / 2, s[1] + sx * s[3] / 2]]
        : [for (sx = [-1, 1], sy = [-1, 1])
              [s[0] + sx * s[2] / 2, s[1] + sy * s[3] / 2]];

// Entretoises du fond (9e champ absent ou 0)
module standoff_sets_all() {
    for (s = standoff_sets)
        if (!(len(s) > 8 && s[8] == 1))
            for (q = standoff_pos(s))
                translate([q[0], q[1], floor_t])
                    standoff_post(len(s) > 4 ? s[4] : 5,
                                  len(s) > 5 ? s[5] : 6.5,
                                  len(s) > 6 ? s[6] : 2.2);
}

// Entretoises suspendues sous le couvercle (9e champ = 1) : pour
// visser un écran ou une carte contre la face intérieure du couvercle
module standoff_sets_lid() {
    for (s = standoff_sets)
        if (len(s) > 8 && s[8] == 1)
            for (q = standoff_pos(s))
                translate([q[0], q[1], seam])
                    rotate([180, 0, 0])
                        standoff_post(len(s) > 4 ? s[4] : 5,
                                      len(s) > 5 ? s[5] : 6.5,
                                      len(s) > 6 ? s[6] : 2.2);
}

// Ouverture USB-C (entrée du module de charge)
module side_usbc_cut() {
    horiz = side_usbc_face == "front" || side_usbc_face == "back";
    w = side_usbc_w + hole_comp;
    h = side_usbc_h + hole_comp;
    on_wall(side_usbc_face, side_usbc_off, side_usbc_z)
        linear_extrude(height = wall + 2, center = true)
            rrect(horiz ? w : h, horiz ? h : w, 2);
}

// Trou rond pour un jack audio châssis
module audio_cut() {
    wall_drill(audio_face, audio_off, audio_z, audio_d);
}

// Trou rond pour un bouton poussoir châssis
module button_cut() {
    wall_drill(button_face, button_off, button_z, button_d);
}

// 4 paires sur les axes médians (jamais sous les entretoises)
module tie_cuts() {
    for (p = [[0, id / 4], [0, -id / 4], [iw / 4, 0], [-iw / 4, 0]])
        translate([p[0], p[1], -1])
            for (s = [-1, 1])
                translate([s * 6, 0, 0])
                    linear_extrude(height = floor_t + 2)
                        rrect(3.5, 9, 1.5);
}

// Encoches de préhension sous le joint : de quoi attraper le bord
// du couvercle pour le déclipser, sur les faces choisies
module thumb_notches() {
    if (notch_sides == "x")
        for (sx = [-1, 1])
            translate([sx * (ow / 2 + 0.4), 0, seam])
                rotate([0, 0, 90])
                    xcapsule(24, 1.6);
    if (notch_sides == "y")
        for (sy = [-1, 1])
            translate([0, sy * (od / 2 + 0.4), seam])
                xcapsule(24, 1.6);
}

// Fenêtre LED dans la paroi arrière : peau fine qui diffuse la
// lumière vers le mur (led_thin = 0 pour une ouverture traversante)
module led_cut() {
    pocket = led_thin <= 0 ? wall + 2 : wall - led_thin;
    yc = led_thin <= 0 ? id / 2 + wall / 2 : id / 2 + pocket / 2;
    translate([led_x, yc, floor_t + led_z])
        rotate([90, 0, 0])
            linear_extrude(height = pocket + 0.01, center = true)
                rrect(led_w, led_h, 3);
}

module board_posts() {
    for (sx = [-1, 1], sy = [-1, 1])
        translate([board_off[0] + sx * hole_x / 2,
                   board_off[1] + sy * hole_y / 2, floor_t])
            difference() {
                cylinder(d = standoff_d, h = standoff_h);
                translate([0, 0, standoff_h - 4])
                    cylinder(d = standoff_pilot, h = 4.5);
            }
}

// Berceau imprimé pour cellule cylindrique : deux joues à encoche
// circulaire (léger serrage, la cellule se clipse) + butées aux bouts
module cell_cradle(L, D) {
    R = D / 2 + 0.25;          // encoche avec un peu de jeu
    axis_h = R - 1;            // axe de la cellule ; elle repose quasi au fond
    lip = (D - 1) / 2;         // demi-ouverture : 0.5 mm de lèvre par côté
    rib_h = axis_h + sqrt(R * R - lip * lip);
    for (s = [-1, 1]) {
        // joue
        translate([s * (L / 2 - 10) - 1.5, 0, 0])
            difference() {
                translate([0, -(D / 2 + 2.5), 0])
                    cube([3, D + 5, rib_h]);
                translate([-0.5, 0, axis_h])
                    rotate([0, 90, 0]) cylinder(r = R, h = 4);
            }
        // butée d'extrémité
        translate([s * (L / 2 + 0.4) - (s < 0 ? 2.4 : 0), -(D / 2 + 2.5), 0])
            cube([2.4, D + 5, D * 0.5]);
    }
}

module cell_holders_all() {
    for (c = cell_holders) {
        rot = len(c) > 2 ? c[2] : 0;
        L = len(c) > 3 ? c[3] : 65;
        D = len(c) > 4 ? c[4] : 18.5;
        translate([c[0], c[1], floor_t])
            rotate([0, 0, rot])
                cell_cradle(L, D);
    }
}

// Cloisons internes, rognées au volume intérieur de la boîte
module dividers_all() {
    for (dv = dividers) {
        rot = len(dv) > 2 ? dv[2] : 0;
        L = len(dv) > 3 ? dv[3] : 40;
        h0 = len(dv) > 4 ? dv[4] : 0;
        th = len(dv) > 5 && dv[5] > 0 ? dv[5] : 1.8;
        nw = len(dv) > 6 ? dv[6] : 0;
        noff = len(dv) > 7 ? dv[7] : 0;
        h = h0 <= 0 ? ih - 0.4 : min(h0, ih - 0.4);
        vented = len(dv) > 8 && dv[8] == 1;
        nb = max(floor((L - 4) / 12), 1);
        // ancrées 0.2 mm dans le fond pour une fusion franche
        intersection() {
            translate([0, 0, floor_t - 0.2])
                rbox(iw - 0.02, id - 0.02, ih + 0.2, inner_r);
            translate([dv[0], dv[1], floor_t - 0.2])
                rotate([0, 0, rot])
                    difference() {
                        translate([-L / 2, -th / 2, 0])
                            cube([L, th, h + 0.2]);
                        if (nw > 0)
                            translate([noff - nw / 2, -th / 2 - 1, h + 0.2 - 8])
                                cube([nw, th + 2, 9]);
                        if (vented)
                            for (i = [0 : nb - 1]) {
                                x = (i - (nb - 1) / 2) * 12 - 4;
                                // créneaux bas, au ras du fond
                                translate([x, -th / 2 - 1, 0.2])
                                    cube([8, th + 2, 4]);
                                // créneaux hauts, sous le couvercle
                                translate([x, -th / 2 - 1, h + 0.2 - 4])
                                    cube([8, th + 2, 4.1]);
                            }
                    }
        }
    }
}

// Compartiments : cadre périmétrique pleine hauteur, rogné aux parois
module compartments_all() {
    for (cp = compartments) {
        w = cp[2]; d = cp[3];
        ns = len(cp) > 6 ? cp[6] : -1;
        nw2 = len(cp) > 7 && cp[7] > 0 ? cp[7] : 8;
        h = ih - 0.4;
        intersection() {
            translate([0, 0, floor_t - 0.2])
                rbox(iw - 0.02, id - 0.02, ih + 0.2, inner_r);
            translate([cp[0], cp[1], floor_t - 0.2])
                difference() {
                    linear_extrude(height = h + 0.2)
                        difference() {
                            square([w + 3.6, d + 3.6], center = true);
                            square([w, d], center = true);
                        }
                    // passage câble en haut du mur choisi
                    if (ns == 0)
                        translate([-nw2 / 2, -(d / 2 + 2.9), h + 0.2 - 8])
                            cube([nw2, 4, 9]);
                    if (ns == 1)
                        translate([-nw2 / 2, d / 2 - 1.1, h + 0.2 - 8])
                            cube([nw2, 4, 9]);
                    if (ns == 2)
                        translate([-(w / 2 + 2.9), -nw2 / 2, h + 0.2 - 8])
                            cube([4, nw2, 9]);
                    if (ns == 3)
                        translate([w / 2 - 1.1, -nw2 / 2, h + 0.2 - 8])
                            cube([4, nw2, 9]);
                }
        }
    }
}

// Aérations de compartiment : nid d'abeille dans le fond…
module compartment_vents_floor() {
    for (cp = compartments)
        if (cp[4] == 1)
            translate([cp[0], cp[1], -1])
                linear_extrude(height = floor_t + 2)
                    vent_pattern2d("hex", cp[2] - 3, cp[3] - 3);
}

// …dans les parois de la boîte en contact avec le compartiment…
module compartment_vents_walls() {
    for (cp = compartments)
        if (len(cp) > 8 && cp[8] == 1) {
            b = max(ih - 16, 8);
            zc = ih / 2;
            if (cp[0] - cp[2] / 2 <= -iw / 2 + 0.3)
                on_wall("left", cp[1], zc)
                    rotate([0, 0, droop_rot("left")])
                        linear_extrude(height = wall + 2, center = true)
                            vent_pattern2d("hex", cp[3] - 6, b);
            if (cp[0] + cp[2] / 2 >= iw / 2 - 0.3)
                on_wall("right", cp[1], zc)
                    rotate([0, 0, droop_rot("right")])
                        linear_extrude(height = wall + 2, center = true)
                            vent_pattern2d("hex", cp[3] - 6, b);
            if (cp[1] - cp[3] / 2 <= -id / 2 + 0.3)
                on_wall("front", cp[0], zc)
                    rotate([0, 0, droop_rot("front")])
                        linear_extrude(height = wall + 2, center = true)
                            vent_pattern2d("hex", cp[2] - 6, b);
            if (cp[1] + cp[3] / 2 >= id / 2 - 0.3)
                on_wall("back", cp[0], zc)
                    rotate([0, 0, droop_rot("back")])
                        linear_extrude(height = wall + 2, center = true)
                            vent_pattern2d("hex", cp[2] - 6, b);
        }
}

// Dégagements dans la JUPE du couvercle : les murets de compartiment
// et les cloisons pleine hauteur qui rejoignent les parois traversent
// la zone de la jupe — on entaille la jupe avec 0.4 de jeu.
module lid_skirt_clearances() {
    for (cp = compartments)
        translate([cp[0], cp[1], seam - lip_h - 1])
            linear_extrude(height = lip_h + 0.95)
                difference() {
                    square([cp[2] + 4.4, cp[3] + 4.4], center = true);
                    square([cp[2] - 0.8, cp[3] - 0.8], center = true);
                }
    for (dv = dividers) {
        h0 = len(dv) > 4 ? dv[4] : 0;
        hh = h0 <= 0 ? ih - 0.4 : min(h0, ih - 0.4);
        if (hh > ih - lip_h - 0.2) {
            th = len(dv) > 5 && dv[5] > 0 ? dv[5] : 1.8;
            translate([dv[0], dv[1], seam - lip_h - 1])
                rotate([0, 0, len(dv) > 2 ? dv[2] : 0])
                    translate([-(dv[3] + 0.8) / 2, -(th + 0.8) / 2, 0])
                        cube([dv[3] + 0.8, th + 0.8, lip_h + 0.95]);
        }
    }
}

// …et dans le couvercle, au-dessus de la zone
module compartment_vents_lid() {
    for (cp = compartments)
        if (cp[5] == 1)
            translate([cp[0], cp[1], seam - 1])
                linear_extrude(height = lid_t + 2)
                    vent_pattern2d("hex", cp[2] - 3, cp[3] - 3);
}

// ------------------------------------------------------------
// Base
// ------------------------------------------------------------
module base() {
    difference() {
        union() {
            difference() {
                shell_slice(0, seam);
                translate([0, 0, floor_t])
                    rbox(iw, id, ih + 2, inner_r);
            }
            if (lid_fix == "screws") screw_posts();
        }
        if (lid_fix == "screws") screw_pilots();
        if (lid_fix == "snap") snap_grooves();
        if (lid_fix == "snap") thumb_notches();
        if (vents) vent_cuts();
        if (usb_cutout) usb_cut();
        if (radar_window) radar_pocket();
        if (led_window) led_cut();
        if (side_usbc) side_usbc_cut();
        if (audio_hole) audio_cut();
        if (button_hole) button_cut();
        if (cable_hole) cable_cut();
        if (tie_slots) tie_cuts();
        cuts_all();
        compartment_vents_floor();
        compartment_vents_walls();
    }
    if (standoffs) board_posts();
    standoff_sets_all();
    cell_holders_all();
    dividers_all();
    compartments_all();
    buttons_solids();
    if (mount_tabs != "none") mount_ears();
}

// ------------------------------------------------------------
// Couvercle
// ------------------------------------------------------------
// En position fermée : tranche haute de la coque + jupe + clips
module lid_assembled() {
    difference() {
        union() {
            shell_slice(seam, H + 1);
            // jupe de centrage
            translate([0, 0, seam - lip_h])
                difference() {
                    rbox(lip_w, lip_d, lip_h + 0.1,
                         max(inner_r - lid_clearance, 1));
                    translate([0, 0, -0.5])
                        rbox(lip_w - 2 * lip_t, lip_d - 2 * lip_t,
                             lip_h + 1, max(inner_r - lip_t, 1));
                }
            // bossages de clip sur la jupe, côtés choisis
            if (lid_fix == "snap") {
                if (snap_sides == "y")
                    for (sy = [-1, 1])
                        translate([0, sy * lip_d / 2, snap_z])
                            xcapsule(snap_len, snap_r);
                else
                    for (sx = [-1, 1])
                        translate([sx * lip_w / 2, 0, snap_z])
                            rotate([0, 0, 90])
                                xcapsule(snap_len, snap_r);
            }
            standoff_sets_lid();
        }
        if (lid_fix == "screws")
            for (sx = [-1, 1], sy = [-1, 1])
                translate([sx * post_x, sy * post_y, 0]) {
                    translate([0, 0, seam - lip_h - 1])
                        cylinder(d = screw_hole, h = H);
                    translate([0, 0, H - (cs_d - screw_hole) / 2])
                        cylinder(d1 = screw_hole, d2 = cs_d,
                                 h = (cs_d - screw_hole) / 2 + 0.01);
                    // dégagement des colonnes dans la jupe
                    translate([0, 0, seam - lip_h - 1])
                        cylinder(d = post_d + 0.8, h = lip_h + 1);
                }
        lid_cuts();
    }
}

// En position d'impression : face extérieure sur le plateau
module lid() {
    translate([0, 0, H]) rotate([180, 0, 0]) lid_assembled();
}

// ------------------------------------------------------------
// Sortie
// ------------------------------------------------------------
if (part == "base") base();
if (part == "lid") lid();
if (part == "both") {
    base();
    translate([ow + 12, 0, 0]) lid();
}
if (part == "assembled") {
    base();
    lid_assembled();
}
if (part == "inserts") inserts_plate();
