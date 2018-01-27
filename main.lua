-- Add required components
require "gooi"

myLines = {}    -- List of all lines in the game
circles = {}    -- List of all circles in the game

-- Add a new line to the game
function drawLine(x1, y1, x2, y2)
    myLines[#myLines+1] = {["x1"] = x1, ["y1"] = y1, ["x2"] = x2, ["y2"] = y2}
end

-- Add a circle to the game
function createCircle(x, y, r)
  circles[#circles+1] = {
    ["x"] = x,
    ["y"] = y,
    ["r"] = r,
    ["dx"] = 0,
    ["dy"] = 0
  }
end

-- Returns the (x, y) of the nearest point on a given line
-- Literally found it through Google. That's allowed.
function ClosestPointOnLineSegment(px,py,x1,y1,x2,y2)
  local dx,dy = x2-x1,y2-y1
  local length = math.sqrt(dx*dx+dy*dy)
  dx,dy = dx/length,dy/length
  local posOnLine = math.min(length, math.max(0,dx*(px-x1) + dy*(py-y1)))
  return x1+posOnLine*dx,y2+posOnLine*dy
end

-- Returns the distance between two points
function distance ( x1, y1, x2, y2 )
  local dx = x1 - x2
  local dy = y1 - y2
  return math.sqrt ( dx * dx + dy * dy )
end

-- Gets the distance from a point to a line
function distFromLine(x, y, line)

    x2, y2 = ClosestPointOnLineSegment(x, y, line["x1"], line["y1"], line["x2"], line["y2"])

    return distance(x, y, x2, y2)

end

-- Check if a circle is intersecting a line
function circleOnLine(circle, line)

  -- If the distance from the circles (x, y) to the line is less than its radius
  if distFromLine(circle.x, circle.y, line) < circle.r then
    return true
  end

  return false

end

-- The function called once at the very start
-- Used to load data that we will need when the program starts
function love.load()

    -- Create a new button and store it in "exitButton"
	exitButton = gooi.newButton({text = "Exit"})

    -- button:onRelease() takes one function as an argument
    -- This function is run once the button is released
    exitButton:onRelease(
    function()
        gooi.confirm({
            text = "Are you sure?",
            ok = function()
                love.event.quit()
            end
        })
	end)

    -- Draw line across bottom to use as the floor
    drawLine(-100, 600, 900, 600)
    createCircle(400, 0, 10)

end

function love.update()
    gooi.update()

end

function love.draw()

    -- Draw all Gooi elements
	gooi.draw()

    -- Draw all lines
    for i=1, #myLines do

        love.graphics.line(myLines[i]["x1"], myLines[i]["y1"],
                            myLines[i]["x2"], myLines[i]["y2"])
    end

    for i=1, #circles do
      love.graphics.circle( "fill", circles[i].x, circles[i].y, circles[i].r )
    end

    x, y = love.mouse.getPosition()
    love.graphics.print(distFromLine(x, y, myLines[1]), 10, 100)

end

function love.mousepressed(x, y, button)
	gooi.pressed()
end

function love.mousereleased(x, y, button)
	gooi.released()
end
