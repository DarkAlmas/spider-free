extends CanvasLayer
# HUD v1 «Нить» (design/hud-v1.html): Здоровье / Stamina / Нить + crosshair + prompt.
const TEAL := Color("#14B8A6"); const VIOLET := Color("#7C3AED"); const GLOW := Color("#5FF2DF")
const HP_C := Color("#22C55E"); const ST_C := Color("#F59E0B"); const TXT := Color("#E6F7F5")
var hp_bar: ProgressBar; var st_bar: ProgressBar; var web_lbl: Label

func _bar(c: Color, y: float) -> ProgressBar:
	var b := ProgressBar.new(); b.position = Vector2(20, y); b.size = Vector2(220, 14); b.show_percentage = false
	var f := StyleBoxFlat.new(); f.bg_color = c; b.add_theme_stylebox_override("fill", f)
	var bg := StyleBoxFlat.new(); bg.bg_color = Color("#0A0B17", 0.7); bg.border_color = VIOLET; bg.set_border_width_all(1)
	b.add_theme_stylebox_override("background", bg); add_child(b); return b

func _lbl(t: String, pos: Vector2, c := TXT, sz := 16) -> Label:
	var l := Label.new(); l.text = t; l.position = pos
	l.add_theme_color_override("font_color", c); l.add_theme_font_size_override("font_size", sz); add_child(l); return l

func _ready():
	_lbl("НИТЬ", Vector2(20, 14), GLOW, 22)
	_lbl("Здоровье", Vector2(248, 46)); hp_bar = _bar(HP_C, 50)
	_lbl("Выносливость", Vector2(248, 68)); st_bar = _bar(ST_C, 72)
	web_lbl = _lbl("Нить: готова", Vector2(20, 94), TEAL)
	var ch := _lbl("+", Vector2.ZERO, GLOW, 28); ch.name = "Crosshair"
	ch.set_anchors_preset(Control.PRESET_CENTER); ch.position -= Vector2(8, 18)
	var p := _lbl("Удерживай ЛКМ — нить / ПКМ отпустить   ·   WASD, Shift, Space, R, Esc", Vector2.ZERO, TXT, 15)
	p.set_anchors_preset(Control.PRESET_CENTER_BOTTOM); p.position = Vector2(400, 680)

func _process(_dt):
	var pl := get_parent().get_node_or_null("Player")
	if pl == null: return
	hp_bar.value = pl.hp; st_bar.value = pl.stamina
	web_lbl.text = "Нить: прицеплена" if pl.attached else ("Нить: готова" if pl.stamina >= 10 else "Нить: мало сил")
	web_lbl.add_theme_color_override("font_color", GLOW if pl.attached else TEAL)
