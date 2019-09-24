-- Controle/Armazenamento do fundo do jogo
background = nil
width = nil
height = nil

-- Tabela de parâmetros do personagem
player = {posx = 0, posy = 0, veloc = 150, img = nil}

-- Timers para sincronização
shooting = true
shotMax = 0.2
timeShot = shotMax

-- Variável para manipular o projétil
imgProj = nil

-- Tabela de controle dos projéteis
projectiles = nil

-- Temporização dos inimigos
dtMaxCreateEnemy = 0.4
dtCurrentEnemy = dtMaxCreateEnemy

-- Estrutura para gerenciar os inimigos
imgEnemy = nil
enemies = {}

-- Controle de estado do jogador e pontoação
alive = true
score = 0

-- Função para controlar a colisão dos aviões
-- Bounding Box - Caixa Continente
function collision(x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function love.load()
  width = 480
  height = 800
  startx = (width - 76) / 2
  starty = height - ((height - 94) / 2) / 2
  
  -- Carga da imagem do jogador
  player.img = love.graphics.newImage('assets/aviao.png')
  player.posx = startx
  player.posy = starty
  
  -- Cargas das outras imagens do ambiente
  background = love.graphics.newImage('assets/fundo.png')
  imgProj = love.graphics.newImage('assets/projetil.png')
  imgEnemy = love.graphics.newImage('assets/inimigo.png')
  
  -- Carga do efeito sonoro do tiro
  shot = love.audio.newSource('assets/tiro.wav', 'static')
end

function love.update(dt)
  -- Tecla de controle para abandonar o jogo
  if love.keyboard.isDown('escape') then
    love.event.push('quit')
  end
  
  -- Controle de movimentação lateral do personagem
  if love.keyboard.isDown('left', 'a') then
    if player.posx > 0 then
      player.posx = player.posx - (player.veloc * dt)
    end
  elseif love.keyboard.isDown('right', 'd') then
    if player.posx < (love.graphics.getWidth() - player.img:getWidth()) then
      player.posx = player.posx + (player.veloc * dt)
    end
  end
  
  -- Controle de temporização de tiros
  timeShot = timeShot - (1 * dt)
  if timeShot < 0 then
    shooting = true
  end
  
  if love.keyboard.isDown('space', 'rctrl', 'lctrl') and shooting and alive then
    newProj = { x = player.posx + player.img:getWidth() / 2, y = player.posy, img = imgProj }
    table.insert(projectiles, newProj)
    shot:play()
    shooting = false
    timeShot = shotMax
  end
  
  -- Continuamos aqui na proxima aula...
end

  
      
  