-- Controle/Armazenamento do fundo do jogo
background = nil
width = nil
height = nil

-- Tabela de parâmetros do personagem
player = {posx = 0, posy = 0, veloc = 300, img = nil}

-- Timers para sincronização
shooting = true
shotMax = 0.2
timeShot = shotMax

-- Variável para manipular o projétil
imgProj = nil

-- Tabela de controle dos projéteis
projectiles = {}

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
  background = love.graphics.newImage('assets/background.png')
  imgProj = love.graphics.newImage('assets/projectile.png')
  imgEnemy = love.graphics.newImage('assets/enemy.png')
  
  -- Carga do efeito sonoro do tiro
  shot = love.audio.newSource('assets/shoot.wav', 'static')
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
  
  -- Atualizar a lista de projéteis
  for i, proj in ipairs(projectiles) do
    proj.y = proj.y - (250 * dt)
    if proj.y < 0 then -- Remove o projétil que saiu da tela
      table.remove(projectiles, i)
    end
  end
  
  -- Temporização da onda de inimigos
  dtCurrentEnemy = dtCurrentEnemy - (1 * dt)
  if dtCurrentEnemy < 0 then
    dtCurrentEnemy = dtMaxCreateEnemy
    -- Criando uma instância do inimigo
    posDynamic = math.random(10, width - imgEnemy:getWidth())
    lvlEnemy = { x = posDynamic, y = -10, img = imgEnemy }
    table.insert(enemies, lvlEnemy)
  end
  
  -- Atualizando posição dos inimigos
  for i, enemy in ipairs(enemies) do
    enemy.y = enemy.y + (200 * dt)
    if enemy.y > 850 then -- remover se ultrapassar o final da tela
      table.remove(enemies, i)
    end
  end
  
  -- Controlando as colisões
  -- Tendo como base que devemos ter menos inimigos do que projéteis
  -- Vamo processar os inimigos primeiros
  for i, enemy in ipairs(enemies) do
    for j, proj in ipairs(projectiles) do
      if collision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(),
        proj.x, proj.y, proj.img:getWidth(), proj.img:getHeight()) then
        table.remove(projectiles, j)
        table.remove(enemies, i)
        score = score + 10
      end
    end
    
    -- Agora a colisão com meu personagem
    if collision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(),
      player.posx, player.posy, player.img:getWidth(), player.img:getHeight()) and alive then
      table.remove(enemies, i)
      alive = false
    end
  end
  
  -- Reiniciar o jogo se R for pressionado
  if not alive and love.keyboard.isDown('r') then
    -- Limpar a lista de inimigos e projéteis da tela
    projectiles = {}
    enemies = {}
    
    -- Reinicializa os temporizadores
    timeShot = shotMax
    dtCurrentEnemy = dtMaxCreateEnemy
    
    -- Movimenta o jogador para a posição inicial
    player.posx = startx
    player.posy = starty
    
    -- Reinicia o placar e vida
    score = 0
    alive = true
  end
  
end

function love.draw()
  love.graphics.draw(background, 0, 0)
  if alive then
    love.graphics.draw(player.img, player.posx, player.posy)
  else
    love.graphics.print("Pressione R para reinicializar ou ESC para sair!",love.graphics.getWidth()/2 - 50,
      love.graphics.getHeight()/2 - 10)
  end
  
  -- Desenhar a lista de projéteis
  for i, proj in ipairs(projectiles) do
    love.graphics.draw(proj.img, proj.x, proj.y)
  end
  
  -- Desenhar a lista de inimigos
  for i, enemy in ipairs(enemies) do
    love.graphics.draw(enemy.img, enemy.x, enemy.y)
  end
  
  -- Pontuação
  love.graphics.setColor(1, 1, 1)
  love.graphics.print("PONTO: " .. tostring(score), 10, 10)
  
end