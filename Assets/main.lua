function love.load()
   love.window.setTitle("Provostative")
   love.window.setMode(800, 600)
   love.graphics.setBackgroundColor(255, 255, 255)
   love.graphics.setDefaultFilter("nearest", "nearest")

   catImages = {
      love.graphics.newImage("Cat_G.png"),
      love.graphics.newImage("Cat_O.png"),
      love.graphics.newImage("Cat_W.png")
   }

   cats = {}
   spawnCat()
   spawnCat()

   spawnTimer = 0
   spawnInterval = 30

   Start = {
      image = love.graphics.newImage("Start.png"),
      x = 140,
      y = 200,
      scale = 20,
      width  = 0,
      height = 0,
      visible = true
   }

   Start.width  = Start.image:getWidth() * Start.scale
   Start.height = Start.image:getHeight() * Start.scale

   CTG = 0
end

function spawnCat()
   local cat = {}
   cat.image = catImages[math.random(1, #catImages)]
   cat.x = math.random(100, 700)
   cat.y = math.random(100, 500)
   cat.scale = 1
   cat.growRate = 0.03
   cat.timer = 0
   cat.width = cat.image:getWidth()
   cat.height = cat.image:getHeight()
   table.insert(cats, cat)
end

function isStartPressed(mx, my)
   return mx >= Start.x and mx <= Start.x + Start.width
      and my >= Start.y and my <= Start.y + Start.height
end

function love.update(dt)
   if CTG == 1 then
      spawnTimer = spawnTimer + dt

      if spawnTimer >= spawnInterval then
         spawnCat()
         spawnTimer = 0
      end

      for i, cat in ipairs(cats) do
         cat.scale = cat.scale + cat.growRate * dt * 60
         cat.timer = cat.timer + dt

         cat.width  = cat.image:getWidth()  * cat.scale
         cat.height = cat.image:getHeight() * cat.scale

         if cat.scale >= 8 then
            print("Too much cuddling! Game over!")
            love.event.quit()
         end
      end
   end
end

function love.draw()
   if Start.visible then
      love.graphics.draw(
         Start.image,
         Start.x,
         Start.y,
         0,
         Start.scale,
         Start.scale
      )
   end

   if CTG == 1 then
      for i, cat in ipairs(cats) do
         love.graphics.draw(
            cat.image,
            cat.x,
            cat.y,
            0,
            cat.scale,
            cat.scale,
            cat.image:getWidth()/2,
            cat.image:getHeight()/2
         )
      end
   end
end

function love.mousepressed(x, y, button)
   if button ~= 1 then return end

   if Start.visible and isStartPressed(x, y) then
      Start.visible = false
      CTG = 1
      return
   end

   if CTG == 1 then
      for i = #cats, 1, -1 do
         local cat = cats[i]
         local dx = x - cat.x
         local dy = y - cat.y
         local distance = math.sqrt(dx*dx + dy*dy)

         if distance < (cat.width / 2) then
            table.remove(cats, i)
            spawnCat()
         end
      end
   end
end
