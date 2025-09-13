extends Control

func fade_in(duration: float):
	var visual = get_node_or_null("VisualLayer")
	if visual == null:
		push_warning("SlideBase: VisualLayer fehlt!")
		return

	if visual is CanvasGroup:
		visual.self_modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(visual, "self_modulate:a", 1.0, duration)
		await tween.finished
	else:
		visual.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(visual, "modulate:a", 1.0, duration)
		await tween.finished

func fade_out(duration: float):
	var visual = get_node_or_null("VisualLayer")
	if visual == null:
		push_warning("SlideBase: VisualLayer fehlt!")
		return

	if visual is CanvasGroup:
		var tween = create_tween()
		tween.tween_property(visual, "self_modulate:a", 0.0, duration)
		await tween.finished
	else:
		var tween = create_tween()
		tween.tween_property(visual, "modulate:a", 0.0, duration)
		await tween.finished


"""
func fade_in(duration: float):
	var visual = get_node_or_null("VisualLayer")
	if not visual:
		push_warning("SlideBase: VisualLayer fehlt!")
		return
	
	visual.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(visual, "modulate:a", 1.0, duration)
	await tween.finished

func fade_out(duration: float):
	var visual = get_node_or_null("VisualLayer")
	if not visual:
		push_warning("SlideBase: VisualLayer fehlt!")
		return
	
	var tween = create_tween()
	tween.tween_property(visual, "modulate:a", 0.0, duration)
	await tween.finished



func fade_in(duration: float):
	var visual = get_node_or_null("VisualLayer")
	if not visual:
		push_warning("SlideBase: VisualLayer fehlt!")
		return
	
	visual.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(visual, "modulate:a", 1.0, duration)
	await tween.finished

func fade_out(duration: float):
	var visual = get_node_or_null("VisualLayer")
	if not visual:
		push_warning("SlideBase: VisualLayer fehlt!")
		return
	
	var tween = create_tween()
	tween.tween_property(visual, "modulate:a", 0.0, duration)
	await tween.finished


func fade_in(duration: float) -> void:
	if not has_node("VisualLayer/picture") or not has_node("VisualLayer/dialogText"):
		push_warning("SlideBase: VisualLayer/picture or dialogText missing.")
		return
	
	var picture = get_node("VisualLayer/picture")
	var dialog = get_node("VisualLayer/dialogText")
	
	picture.modulate.a = 0.0
	dialog.modulate.a = 0.0
	
	var tween = create_tween()
	tween.tween_property(picture, "modulate:a", 1.0, duration)
	tween.tween_property(dialog, "modulate:a", 1.0, duration)
	
	await tween.finished

func fade_out(duration: float) -> void:
	if not has_node("VisualLayer/picture") or not has_node("VisualLayer/dialogText"):
		push_warning("SlideBase: VisualLayer/picture or dialogText missing.")
		return
	
	var picture = get_node("VisualLayer/picture")
	var dialog = get_node("VisualLayer/dialogText")
	
	var tween = create_tween()
	tween.tween_property(picture, "modulate:a", 0.0, duration)
	tween.tween_property(dialog, "modulate:a", 0.0, duration)
	
	await tween.finished
"""
