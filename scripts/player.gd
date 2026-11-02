extends CharacterBody3D
# Original hero "Нить" — walk/run/jump + rope swing (custom spring).
const WALK := 7.0
const RUN := 13.0
const JUMP := 9.0
const GRAV := 22.0
const WEB_RANGE := 120.0
@onready var pivot: Node3D = $Pivot
@onready var cam: Camera3D = $Pivot/SpringArm3D/Camera3D
@onready var rope: MeshInstance3D = $Rope
var yaw := 0.0
var pitch := -0.2
var attached := false
var anchor := Vector3.ZERO
var rope_len := 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	rope.top_level = true

func _unhandled_input(ev):
	if ev is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		yaw -= ev.relative.x * 0.003
		pitch = clamp(pitch - ev.relative.y * 0.003, -1.3, 0.6)
	elif ev is InputEventMouseButton and ev.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if ev.button_index == MOUSE_BUTTON_LEFT: shoot_web()
		elif ev.button_index == MOUSE_BUTTON_RIGHT: release_web()
	elif ev is InputEventKey and ev.pressed and ev.keycode == KEY_ESCAPE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif ev is InputEventKey and ev.pressed and ev.keycode == KEY_R:
		global_position = Vector3(0, 2, 0); velocity = Vector3.ZERO; release_web()

func shoot_web():
	var from := cam.global_position
	var to := from - cam.global_transform.basis.z * WEB_RANGE
	var q := PhysicsRayQueryParameters3D.create(from, to); q.exclude = [get_rid()]
	var hit := get_world_3d().direct_space_state.intersect_ray(q)
	if hit:
		attached = true; anchor = hit.position
		rope_len = max(global_position.distance_to(anchor) * 0.9, 3.0)

func release_web():
	if attached: velocity += Vector3.UP * 4.0
	attached = false

func _physics_process(dt):
	pivot.rotation = Vector3(pitch, yaw, 0)
	var inp := Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	var k := Vector2(float(Input.is_key_pressed(KEY_D)) - float(Input.is_key_pressed(KEY_A)), float(Input.is_key_pressed(KEY_S)) - float(Input.is_key_pressed(KEY_W)))
	if k != Vector2.ZERO: inp = k.normalized()
	var dir := (Basis(Vector3.UP, yaw) * Vector3(inp.x, 0, inp.y))
	var spd := RUN if Input.is_key_pressed(KEY_SHIFT) else WALK
	if is_on_floor():
		velocity.x = lerp(velocity.x, dir.x * spd, 12 * dt)
		velocity.z = lerp(velocity.z, dir.z * spd, 12 * dt)
		if Input.is_key_pressed(KEY_SPACE): velocity.y = JUMP
	else:
		velocity.y -= GRAV * dt
		velocity += dir * 6.0 * dt  # air control
	if attached:
		var d := global_position - anchor
		var dist := d.length()
		if dist > rope_len:
			var n := d / dist
			global_position = anchor + n * rope_len  # rope constraint
			var radial := velocity.dot(n)
			if radial > 0: velocity -= n * radial
			velocity += -n * (dist - rope_len) * 30.0 * dt
		if Input.is_key_pressed(KEY_SPACE): rope_len = max(rope_len - 15 * dt, 3.0)  # reel in
	move_and_slide()
	if global_position.y < -30: global_position = Vector3(0, 2, 0); velocity = Vector3.ZERO
	_draw_rope()

func _draw_rope():
	rope.visible = attached
	if not attached: return
	var a := global_position + Vector3.UP * 0.8
	var mid := (a + anchor) / 2
	var len := a.distance_to(anchor)
	rope.global_position = mid
	(rope.mesh as CylinderMesh).height = len
	var up := (anchor - a).normalized()
	var side := up.cross(Vector3.FORWARD if abs(up.z) < 0.9 else Vector3.RIGHT).normalized()
	rope.global_basis = Basis(side, up, side.cross(up))
