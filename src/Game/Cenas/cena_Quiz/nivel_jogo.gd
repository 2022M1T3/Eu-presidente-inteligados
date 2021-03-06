#Envia as perguntas para o Panel
#Envia as perguntas para o Panel
extends Node
enum TipoPergunta { TEXTO, IMAGEM, VIDEO, AUDIO }
export(Resource) var db_perguntas
export(Color) var color_right
export(Color) var color_wrong
var buttons := []
# declarar os itens da tabela informacao_pergunta como variáveis
onready var texto_pergunta := $informacao_pergunta/texto_pergunta
onready var imagem_pergunta := $informacao_pergunta/Panel/imagem_pergunta
onready var video_pergunta := $informacao_pergunta/Panel/video_pergunta
onready var audio_pergunta := $informacao_pergunta/Panel/audio_pergunta
func _ready() -> void:
	for _button in $resposta.get_children():
		buttons.append(_button)
	Global.stop = 0  #retorna ao estado inicial quando a cena é chamada
	load_quiz()
	

func load_quiz() -> void:
	
# Mostra a mensagem de Fim após o termino do quiz
	if Global.index >= db_perguntas.db.size():
		return
		
		
# informações nos botões
	texto_pergunta.text = str(db_perguntas.db[Global.index].Informacao_Pergunta)
	for i in buttons.size():
		buttons[i].text = str(db_perguntas.db[Global.index].opcoes[i])
		buttons[i].connect("pressed", self, "buttons_answer", [buttons[i]])
		
		
		
# Pegar as informações do banco e passar para as variáveis da tabela de informacao_pergunta
	match db_perguntas.db[Global.index].type:
		TipoPergunta.TEXTO:
			$informacao_pergunta/Panel.hide()
			
		TipoPergunta.IMAGEM:
			$informacao_pergunta/Panel.show()
			imagem_pergunta.texture = db_perguntas.db[Global.index].imagem_pergunta
			
		TipoPergunta.VIDEO:
			$informacao_pergunta/Panel.show()
			video_pergunta.stream = db_perguntas.db[Global.index].video_pergunta
			video_pergunta.play()
			
		TipoPergunta.AUDIO:
			$informacao_pergunta/Panel.show()
			imagem_pergunta.texture = load("res://Audio/march.mp3")
			audio_pergunta.stream = db_perguntas.db[Global.index].audio_pergunta
			audio_pergunta.play()
	
# Determina a cor do botão de acordo com a resposta
func buttons_answer(button) -> void:
	print(button.text)
	if Global.index != Global.indexEscola and Global.index != Global.indexMercado and Global.index != Global.indexPrefeitura:
	#detecta se o corpo está dentro de um espaço fechado, para haver alteração entre a mecânica do jogo
		if db_perguntas.db[Global.index].correct == button.text and Global.contador < 10 and Global.stop == 0:
			Global.contador += 1
			button.modulate = color_right
			Global.stop = 1  #impede que o botão seja chamado novamente, requerendo que a cena seja chamada novamente
			Global.correto = 1 #determina que a resposta é correta
			Global.contador_easter_egg += 1
		elif db_perguntas.db[Global.index].correct == button.text and Global.contador >= 10 and Global.stop == 0:
			button.modulate = color_right
			Global.stop = 1
			Global.correto = 1
			Global.contador_easter_egg += 1
		else:
			if Global.stop == 0:
				button.modulate = color_right
				Global.contador -= 2 #subrai pontos da HUD
				Global.stop = 1
				Global.correto = 0 #determina que a resposta é errada
				
	else: 
		if db_perguntas.db[Global.index].correct == button.text and Global.contador < 10 and Global.stop == 0:
			Global.contador += 1
			button.modulate = color_right
			Global.stop = 1
			Global.correto = 1
			Global.contador_easter_egg += 1
			if Global.index == Global.indexEscola:
				Global.acertouEscola = 1
			if Global.index == Global.indexMercado:
				Global.acertouMercado = 1
			if Global.index == Global.indexPrefeitura:
				Global.acertouPrefeitura = 1
			
		elif db_perguntas.db[Global.index].correct == button.text and Global.contador >= 10 and Global.stop == 0:
			button.modulate = color_right
			Global.stop = 1
			Global.correto = 1
			Global.contador_easter_egg += 1
			if Global.index == Global.indexEscola:
				Global.acertouEscola = 1
			if Global.index == Global.indexMercado:
				Global.acertouMercado = 1
			if Global.index == Global.indexPrefeitura:
				Global.acertouPrefeitura = 1

		else:
			if Global.stop == 0:
				button.modulate = color_right
				Global.stop = 1
				Global.correto = 0
	audio_pergunta.stop()
	audio_pergunta.stop()
	
	yield(get_tree().create_timer(1), "timeout") #determina um certo tempo até a próxima cena ser chamada
	
	
	for bt in buttons:
		bt.modulate = Color.white
		bt.disconnect("pressed", self, "buttons_answer")
		
	audio_pergunta.stream = null
	video_pergunta.stream =  null
	
# Avança para a proxima pergunta
	Global.index += 1
	
#Voltar para o mundo aberto
	get_tree().change_scene("res://Cenas/cena_Explicacao/cena_Explicacao.tscn")

func _on_opcao1_pressed():
	if Global.mudo == 0: 
		$AudioStreamPlayer1.stream = load("res://Audio/pencil_write.ogg")
		$AudioStreamPlayer1.play()
	else: 
		$AudioStreamPlayer1.stop()
func _on_opcao2_pressed():
	if Global.mudo == 0: 
		$AudioStreamPlayer1.stream = load("res://Audio/pencil_write.ogg")
		$AudioStreamPlayer1.play()
	else: 
		$AudioStreamPlayer1.stop()
		
