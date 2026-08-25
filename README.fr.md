# ESP32 Box Builder

*Français · [English version](README.md)*

Concepteur de boîtiers imprimés en 3D pour l'électronique maker
(ESP32, capteurs, modules…) : une interface web locale où tu poses
tes connecteurs, entretoises PCB, compartiments et aérations en
glisser-déposer, et qui génère les STL prêts à trancher.

**Essaie en ligne, sans rien installer :**
**https://timiliris.github.io/esp32-box/builder.html**
— la génération des STL tourne dans ton navigateur (OpenSCAD
WebAssembly, ~1 à 3 min par pièce). En local avec OpenSCAD installé,
c'est nettement plus rapide.

Boîtier au design moderne : coque continue à gros rayons, arêtes en
congé, couvercle affleurant **clipsé sans aucune vis visible**.
Un seul fichier source OpenSCAD ([esp32-box.scad](esp32-box.scad)),
entièrement paramétrique.

![Aperçu du boîtier](preview/apercu-M-ferme.png)

| | |
|---|---|
| ![Aérations](preview/apercu-aerations.png) | ![Compartiment](preview/apercu-compartiment.png) |
| *Aérations posables : nid d'abeille, grille, fentes* | *Compartiment ventilé pour isoler un capteur* |
| ![Boutons](preview/apercu-boutons.png) | ![Inserts](preview/apercu-inserts.png) |
| *Boutons pour tact switch 6×6 : languette et piston* | *Fenêtres clipsables à imprimer en transparent* |

## Installation

Prérequis : [OpenSCAD](https://openscad.org) et Python 3 (inclus sur
macOS ; sur Debian/Ubuntu : `sudo apt install openscad python3`).

```bash
git clone https://github.com/timiliris/esp32-box.git
cd esp32-box
python3 builder-server.py
```

Sur macOS, double-cliquer `builder.command` fait la même chose.
L'interface s'ouvre sur http://127.0.0.1:8765.

## Builder visuel

Le serveur local (stdlib Python, port 8765) sert l'interface et
active la **génération directe** : boutons « Générer le STL » qui
appellent l'OpenSCAD installé et téléchargent le fichier prêt à trancher
(**STL binaire**, ~5× plus léger que l'ASCII ; si le port 8765 est
pris, le serveur bascule tout seul sur le suivant et l'interface le
retrouve).
Ouvrir `builder.html` seul marche aussi : l'interface retombe alors
sur les commandes à copier.

L'interface s'organise autour d'un **rail d'icônes** à gauche
(façon JetBrains) : panneau **Découpes** (palette par catégories),
**Implantation du fond** (PCB, socles, cloisons, compartiments),
**Objets** (liste du projet) et **Boîtier** (dimensions, options,
fixation murale) — l'inspecteur de sélection reste épinglé en bas.
Le panneau suit l'onglet actif (Fond ↔ implantation).

Dans l'interface : édition 2D face
par face (avant / arrière / flancs / **couvercle** / **fond** —
écran sur le dessus, aérations dessous, tout est possible),
glisser-déposer des découpes avec aimantation (centres, alignements
entre découpes, grille 0.5 mm), **zoom** Ctrl+molette et panoramique
molette, palette de connecteurs prêts avec infobulles (USB-C, USB-A,
jack, poussoirs, PG7, rocker, fenêtres LED/radar), panneau
**Objets** listant tout le projet (clic = y aller), **pattes de
fixation murale** (2 ou 4 œillets Ø 4.2 imprimés avec la base),
zones interdites affichées (coins arrondis, bande jupe/clips), et un
outil
d'**entraxes PCB** : choisis une carte ou un module (ou entre
l'entraxe mesuré), pose le groupe d'entretoises sur le fond,
déplace/pivote-le. La liste couvre les cartes (DevKit), les
**plaques de proto** des kits standard (2×8 à 9×15 cm, trous d'angle
Ø2 centrés à ~2 mm des bords : entraxe = dimension − 4, mesuré ≈) et
les **capteurs/modules courants** — GY-BME280 (2 trous · 10,
vérifié), OLED 0.96″ SSD1306, GY-521, buck LM2596… — avec gestion
des cartes à **2 trous** (paire ou diagonale) et plots fins +
avant-trous M2 pour les petits modules. Les cotes marquées ≈ sont
les valeurs usuelles des clones : vérifie au pied à coulisse, ça
varie d'un fabricant à l'autre.
Des **cloisons internes** pour isoler un capteur (que le BME280 ne
lise pas la chaleur de l'alim…) : murets imprimés avec la base,
pleine hauteur (jusqu'au couvercle) ou partielle, épaisseur réglable,
**passage de câble** optionnel en haut, et option **créneaux
d'aération** haut + bas pour laisser circuler l'air. Fais-les
dépasser dans les parois : elles sont rognées au volume intérieur et
se raccordent proprement
(`dividers=[[cx,cy,rot,long,haut,ép,passage,décal,aérée],…]`).
Et des **compartiments** complets : un cadre fermé pleine hauteur
autour d'une zone, avec en option un **nid d'abeille découpé dans le
fond dessous et dans le couvercle au-dessus** — l'air extérieur
traverse le compartiment en cheminée, le capteur mesure l'air de la
pièce tout en étant isolé de la chaleur de la boîte. Passage de
câble sur le mur au choix
(`compartments=[[cx,cy,l,p,aér_fond,aér_couv,côté,larg],…]` —
le couvercle doit être régénéré si l'aération couvercle est active).
Même chose pour les **socles de cellule** (18650 / 21700 / 14500) :
un berceau imprimé à deux joues clipsantes et butées d'extrémité,
posé sur le fond comme un objet, déplaçable et pivotable
(`cell_holders=[[cx,cy,rot,longueur,Ø],…]` côté .scad).
En bas, la commande OpenSCAD prête à copier (base + couvercle) —
tout passe par les paramètres `cuts` et `standoff_sets` du .scad.
Le projet est sauvegardé automatiquement dans le navigateur.

Aussi : **aperçu 3D** en bas à droite (boîte fermée avec toutes les
découpes, rotation à la souris, repliable) et **annuler / rétablir**
(boutons dans l'en-tête, Cmd+Z / Cmd+Maj+Z) — un glisser ou une
saisie ne comptent que pour une seule étape.

## Tailles

Dimensions **intérieures** (extérieur = +4.8 mm en X/Y) :

| Préréglage | Intérieur (mm) | Usage type |
|---|---|---|
| S | 70 × 50 × 30 | un ESP32 seul + capteur (POG Sensor) |
| M | 100 × 70 × 40 | ESP32 + breadboard mini / relais |
| L | 140 × 100 × 50 | montages multi-modules, alim |
| XL | 180 × 130 × 60 | gros fourre-tout |
| custom | `custom_inner = [x, y, z]` | ce que tu veux |

## Impression

- **Sans supports**, base et couvercle s'impriment tels quels
  (le couvercle est déjà modélisé face extérieure sur le plateau).
- 0.2 mm, 2–3 périmètres, 15 % de remplissage suffisent.
- PLA ou PETG. PETG si le boîtier chauffe (alim, relais) — et pour
  des clips plus souples.
- Si le couvercle est trop serré/lâche : ajuster `lid_clearance`
  (0.25 par défaut).
- **Compensation FDM intégrée** : tous les trous et découpes
  fonctionnels sont élargis de `hole_comp` (0.3 mm par défaut) pour
  compenser le rétreint d'impression — les cotes que tu donnes sont
  les cotes nominales du connecteur. Les trous ronds des parois sont
  en **goutte d'eau** (sommet à 45°, `teardrop`) : pas
  d'affaissement ni de support. Les deux se règlent dans le builder
  (« Jeu perçage » / « Goutte d'eau »).

## Fermeture

- Par défaut `lid_fix = "snap"` : couvercle clipsé (bossages sur la
  jupe, rainures dans les parois), zéro vis visible. Pour l'ouvrir :
  pousser le bord du couvercle vers le haut par une des deux encoches
  latérales.
- `snap_sides` / `notch_sides` (`x` = flancs, `y` = avant/arrière) :
  place les clips et les encoches sur des faces **sans connecteur**,
  pour déclipser sans gêner les câbles. Défaut : les flancs.
- `lid_fix = "screws"` : 4 × **M3×10** fraisées sur le dessus si tu
  veux verrouiller (avant-trou 2.7, autotaraudeuse ou M3 machine).
- Carte : 4 × **M2.5** autotaraudeuses sur les entretoises
  (avant-trou 2.2).

## Options (Customizer OpenSCAD ou `-D` en CLI)

- `part` : `base`, `lid`, `both` ou `assembled` (vue fermée)
- `vents` : la bande de fentes automatique sur les flancs. Pour des
  aérations **posables** où tu veux (parois, couvercle, fond), la
  palette du builder a quatre motifs qui remplissent une zone à
  dimensionner : fentes verticales, fentes horizontales, grille
  ronde en quinconce et nid d'abeille (types `vslots` / `hslots` /
  `grid` / `hex` dans `cuts`).
- `usb_cutout` : ouverture USB face avant (position/taille réglables)
- `radar_window` : zone amincie à 1 mm dans la paroi avant pour un
  radar mmWave (LD2410B) — le radar voit à travers, l'extérieur reste
  lisse. Jamais de métal devant le radar.
- **USB-C encastré** : pour une prise USB-C femelle **nue** (l'armature
  métal à souder, sans breakout) — support-canal intégré derrière la
  paroi, nez de la prise au ras extérieur. L'ouverture (8.7 × 2.9)
  laisse passer la languette du câble mais pas l'armature : brancher
  pousse la prise contre le fond du canal, débrancher la plaque
  contre la paroi — zéro contrainte sur les soudures, zéro colle.
  Insertion par le haut, pont de maintien à l'arrière, fils vers le
  dos.
- **Boutons pour tact switch 6×6** (les petits boutons noirs standard
  à 4 pattes), deux styles, avec **berceau intégré** côté intérieur :
  tu soudes deux fils sur le switch et tu le glisses dans son logement
  par le haut, l'alignement est garanti par construction.
  « Bouton languette » = imprimé en place (languette flexible dans la
  paroi, disque affleurant dehors, zéro assemblage) ; « Bouton
  poussoir » = piston coulissant (capuchon généré avec la planche
  Inserts, inséré par l'intérieur, retenu par sa collerette — le
  ressort du switch fait le rappel).
- `led_window` : fenêtre LED dans la paroi arrière (défaut 74 × 12) —
  peau de `led_thin` mm laissée côté extérieur qui sert de diffuseur
  (imprimer en blanc/naturel), ou `led_thin = 0` pour une ouverture
  traversante. Pensé pour une lueur indirecte vers le mur.
- **Fenêtres clipsables (inserts)** : les découpes de type `insert`
  créent un trou traversant à **feuillure** dans la paroi, et
  `part="inserts"` génère les fenêtres correspondantes — plaque
  affleurante dehors, corps traversant, deux bossages qui clipsent
  derrière la paroi. L'intérieur est **évidé** : seule une membrane
  fine (« Peau », 0.8 par défaut) reste au centre — les LED diffusent
  bien, le radar voit à travers — et **peau 0 = cadre ouvert** sans
  membrane, pour un laser ToF ou tout capteur qui doit voir à l'air
  libre. Imprime-les en **PETG transparent** (LED, radar)
  ou **blanc** (diffuseur) pendant que la boîte est dans ta couleur.
  Dans le builder : « Fenêtre LED », « Fenêtre radar » et « Insert
  libre » dans la palette, et une troisième carte « Inserts » en bas
  pour générer la pièce. « Fenêtre libre » reste la version à paroi
  amincie mono-matière.
- `cable_hole` : trou arrière Ø12.5 pour presse-étoupe PG7
- `standoffs` : entretoises de carte, entraxes `hole_x` / `hole_y`
  (défaut 44.5 × 20.5 — **à mesurer sur ta carte**, ça varie selon
  les clones de DevKit)
- `tie_slots` : fentes zip-tie dans le fond pour attacher le vrac

## Regénérer un STL en CLI

```bash
openscad -o boitier.stl -D 'size_preset="L"' -D 'part="base"' -D 'cable_hole=true' esp32-box.scad
```

## Variantes incluses

`esp32-box-S-capteur-base.stl` : base S avec fenêtre radar (pour le
POG Sensor BMP280 + LD2410B) — radar centré face avant, USB décalé à
droite pour ne pas passer sous le module radar, aérations pour que le
BMP280 lise la température ambiante et pas celle de l'ESP32.
(Couvercle : le `esp32-box-S-lid.stl` standard.)

`esp32-box-powerbank-{base,lid}.stl` : intérieur 112 × 80 × 42 pour
un module power bank multi-ports (ouverture 64 × 10 face avant pour
la rangée micro-USB / USB-C / 2× USB-A), une 18650, un perf board
70 × 30 et une bande LED de 70 mm (fenêtre diffusante 74 × 12 au dos,
lueur vers le mur). En plus, **au dos sous la fenêtre LED** : entrée
USB-C du module de charge (10 × 6, `side_usbc`) et sortie audio jack
Ø 6.5 (`audio_hole`) ; **en façade** : trou Ø 7.2 pour un petit
bouton poussoir châssis (`button_hole`, à droite des ports).
Aérations coupées sur cette variante (la grande ouverture avant
suffit à ventiler). Chaque ouverture est paramétrique : face
(`*_face` : back/front/left/right), décalage (`*_off`) et hauteur
(`*_z`). Vérifie la position de tes connecteurs avant d'imprimer :
cotes estimées depuis la photo du module.
