extends Node3D
# Procedural city block: ground + box buildings.
func _ready():
	var rng := RandomNumberGenerator.new(); rng.seed = 42
	_box(Vector3(0,-0.5,0), Vector3(200,1,200), Color(0.25,0.27,0.3))
	for x in range(-4,5):
		for z in range(-4,5):
			if abs(x) <= 0 and abs(z) <= 0: continue
			if rng.randf() < 0.25: continue
			var h := rng.randf_range(12, 45)
			var w := rng.randf_range(8, 13)
			_box(Vector3(x*20, h/2, z*20), Vector3(w,h,w), Color.from_hsv(rng.randf_range(0.55,0.65), 0.2, rng.randf_range(0.4,0.8)))
	var sun := DirectionalLight3D.new(); sun.rotation_degrees = Vector3(-50,30,0); sun.shadow_enabled = true; add_child(sun)
	var env := WorldEnvironment.new(); var e := Environment.new()
	e.background_mode = Environment.BG_COLOR; e.background_color = Color(0.55,0.7,0.9)
	e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR; e.ambient_light_color = Color(0.6,0.6,0.7)
	env.environment = e; add_child(env)

func _box(pos: Vector3, size: Vector3, c: Color):
	var b := StaticBody3D.new(); b.position = pos
	var m := MeshInstance3D.new(); var bm := BoxMesh.new(); bm.size = size
	var mat := StandardMaterial3D.new(); mat.albedo_color = c; bm.material = mat; m.mesh = bm
	var cs := CollisionShape3D.new(); var sh := BoxShape3D.new(); sh.size = size; cs.shape = sh
	b.add_child(m); b.add_child(cs); add_child(b)
