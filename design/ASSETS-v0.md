# «Нить» — ASSETS v0 для Programming (Godot 4 / DarkAlmas/spider-free)

## Палитра
| Роль | Hex |
|------|-----|
| Teal (костюм / нить) | `#14B8A6` |
| Violet (костюм / акцент) | `#7C3AED` |
| Glow | `#5FF2DF` |
| Charcoal skyline | `#0A0B17` |
| Sky top | `#1A1240` |
| Sky mid | `#3B1F66` |
| HP | `#22C55E` |
| Stamina | `#F59E0B` |
| UI text | `#E6F7F5` |

## Design отдаёт в v0
- `hud-v1.html` + `hud-v1.png` — меню + HUD wireframe
- Силуэт: геометрический костюм teal/violet (clip-path в HTML) — без красно-синего Spidey
- Low-poly квартал: чёрные блоки разной высоты, читаемые с дистанции
- Этот файл

## Design НЕ отдаёт в v0
- Риг / анимации / полноценный меш героя
- Полный город / текстуры зданий
- Звук / VFX паутины

## Сцены (предложение)
- `MainMenu.tscn` — Продолжить / Новая / Настройки
- `CityBlock_v0.tscn` — квартал из PrimitiveMesh
- `Player.tscn` — CharacterBody3D + капсула/силуэт
- `HUD.tscn` — HP / stamina / Нить / компас / prompt
