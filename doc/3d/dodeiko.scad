// Dodekaeder + Ikosaeder (Modell 1) + Verbindungsstäbe (Modell 2)

$fn = 60;
edge = 80;
rod_d = 8;
phi = (1 + sqrt(5)) / 2;

// ---------- Basisdaten ----------
pts_raw = [
    [ 1,  1,  1], [ 1,  1, -1], [ 1, -1,  1], [ 1, -1, -1],
    [-1,  1,  1], [-1,  1, -1], [-1, -1,  1], [-1, -1, -1],
    [ phi,  1/phi, 0], [ phi, -1/phi, 0], [-phi,  1/phi, 0], [-phi, -1/phi, 0],
    [0,  phi,  1/phi], [0,  phi, -1/phi], [0, -phi,  1/phi], [0, -phi, -1/phi],
    [ 1/phi, 0,  phi], [ 1/phi, 0, -phi], [-1/phi, 0,  phi], [-1/phi, 0, -phi]
];
raw_edge = norm(pts_raw[0] - pts_raw[12]);
sc = edge / raw_edge;
v = [for(p = pts_raw) p * sc];

faces = [
    [0, 12, 4, 18, 16], [0, 12, 13, 1, 8], [0, 8, 9, 2, 16],
    [2, 14, 6, 18, 16], [12, 4, 10, 5, 13], [11, 10, 5, 19, 7],
    [13, 5, 19, 17, 1], [1, 8, 9, 3, 17], [11, 6, 18, 4, 10],
    [15, 14, 6, 11, 7], [15, 3, 17, 19, 7], [14, 2, 9, 3, 15]
];

// Ikosaeder-Ecken = Dodekaeder-Flächenmittelpunkte
ico_verts = [for(face = faces) 
    let(verts = [for(i = face) v[i]])
    [
        (verts[0][0]+verts[1][0]+verts[2][0]+verts[3][0]+verts[4][0])/5,
        (verts[0][1]+verts[1][1]+verts[2][1]+verts[3][1]+verts[4][1])/5,
        (verts[0][2]+verts[1][2]+verts[2][2]+verts[3][2]+verts[4][2])/5
    ]
];

// Ikosaeder-Kantenlänge
ico_dists = [
    for(i = [0:10])
        for(j = [i+1:11])
            norm(ico_verts[i] - ico_verts[j])
];
ico_edge = min(ico_dists);

// Ikosaeder-Kanten
ico_edges = [
    for(i = [0:10])
        for(j = [i+1:11])
            if(abs(norm(ico_verts[i] - ico_verts[j]) - ico_edge) < 0.1)
                [i, j]
];

// ---------- Stab-Modul (mit Kugeln an den Enden) ----------
module rod(a, b, d) {
    vec = b - a;
    len = norm(vec);
    union() {
        translate(a)
            rotate([0, acos(vec[2]/len), atan2(vec[1], vec[0])])
                cylinder(d = d, h = len);
        translate(a) sphere(d = d * 1.2);
        translate(b) sphere(d = d * 1.2);
    }
}

// ---------- Modell 1: Dodekaeder + Ikosaeder ----------
module model1() {
    union() {
        // Dodekaeder
        for(face = faces) {
            verts = [for(i = face) v[i]];
            for(i = [0:4]) {
                rod(verts[i], verts[(i+1)%5], rod_d);
            }
        }
        // Ikosaeder
        for(e = ico_edges) {
            rod(ico_verts[e[0]], ico_verts[e[1]], rod_d);
        }
    }
}

// ---------- Modell 2: Verbindungsstäbe ----------
module model2() {
    union() {
        for(i = [0:11]) {
            face = faces[i];
            center = ico_verts[i];
            for(j = face) {
                rod(center, v[j], rod_d);
            }
        }
    }
}

// ---------- Export ----------
// Zum Exportieren: nur EINES aktivieren!
model1();
//model2();