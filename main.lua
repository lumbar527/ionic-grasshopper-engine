function do_intersect(x1,y1,x2,y2,x3,y3,x4,y4)
	-- lines are 1-2 and 3-4
	
    if x1 == x2 then
        x1 = x1 + 1
    end
    if y1 == y2 then
        y1 = y1 + 1
    end
    if x3 == x4 then
        x3 = x4 + 1
    end
    if y3 == y4 then
        y3 = y4 + 1
    end

	t = ((x1 - x3) * (y3 - y4)) - ((y1 - y3) * (x3 - x4))
	t_div = ((x1 - x2) * (y3 - y4)) - ((y1 - y2) * (x3 - x4))
	
	if t_div ~= 0 then
        t = t / t_div
        p_x, p_y = x1 + t * (x2 - x1), y1 + t * (y2 - y1)
        
        -- if p_x>=math.min(x1,x2) and p_x<=math.max(x1,x2) and p_y>=math.min(y1,y2) and p_y<=math.max(y1,y2) and p_x>=math.min(x3,x4) and p_x<=math.max(x3,x4) and p_y>=math.min(y3,y4) and p_y<=math.max(y3,y4) then
        if p_x>=min(x3,x4) and p_x<=max(x3,x4) and p_y>=min(y3,y4) and p_y<=max(y3,y4) then
            dist=math.sqrt((x1-p_x)^2 + (y1-p_y)^2)
            -- if math.sqrt((x2-p_x)^2 + (y2-p_y)^2) > math.sqrt((x1-x2)^2 + (y1-y2)^2) and math.sqrt((x1-p_x)^2 + (y1-p_y)^2) < math.sqrt((x1-x2)^2 + (y1-y2)^2) then
            if (x2 - x1 < 0 and p_x - x1 >= 0) or (x2 - x1 >= 0 and p_x - x1 < 0) then
                dist = -dist
            end

            return {true, p_x, p_y, 0, 0, dist}
        end
	end
	
	return {false, 0, 0, 0, 0, 0}
end

function min(a,b)
    if a < b then
        return a
    else
        return b
    end
end

function max(a,b)
    if a > b then
        return a
    else
        return b
    end
end

-- function make_cplane(x,y,a,d,w) -- returns a line
--     a = a / 180 * math.pi -- a is given in angles; math. uses radians
--     -- center of the camera
--     cpx = x + math.cos(a) * d
--     cpy = y + math.sin(a) * d

--     -- if playdate.buttonIsPressed(playdate.kButtonA) then
--         -- gfx.drawLine(x,y,cx,cy)
--     -- end

--     -- get the ends
--     ox = math.cos(a + math.pi / 2) * w/2
--     oy = math.sin(a + math.pi / 2) * w/2
--     x1 = cpx + ox
--     x2 = cpx - ox
--     y1 = cpy + oy
--     y2 = cpy - oy

--     return {x1,y1,x2,y2}
-- end

function make_cplane(cx,cy,a,cd,cw)
	--camera x,y, angle, camera dist,width
	-- a = a

	cdx=cx+math.sin(a*math.pi*2)*cd
	cdy=cy+math.cos(a*math.pi*2)*cd
	
	px1=cdx+math.sin((a+0.25)*math.pi*2)*cw/2
	py1=cdy+math.cos((a+0.25)*math.pi*2)*cw/2
	px2=cdx+math.sin((a-0.25)*math.pi*2)*cw/2
	py2=cdy+math.cos((a-0.25)*math.pi*2)*cw/2
	
	-- circfill(cx,cy,2,10)
	-- line(cx,cy,cdx,cdy,12)
	
	-- line(px1,py1,px2,py2,12)
	
	return {px1,py1,px2,py2}
end

function init()
    love.mouse.setRelativeMode(true)
	-- playdate.display.setRefreshRate(0)
	pts={}
    triangle_function = tri
    sat = true
	p={x=32,y=32,z=10,a=-0.6,va=0.25}
--[[	m={
		{x=0,y=0,z1=0,z2=20},
		{x=20,y=0,z1=0,z2=20},
		{x=0,y=20,z1=0,z2=20},
		{x=20,y=20,z1=0,z2=20},
	}]]--
	-- local xx = 0
	-- local yy = 0
	-- local zz = -5
	triangles=
	{
		{
			{x=0,y=0,z=0},
			{x=0,y=0,z=20},
			{x=20,y=0,z=0}
		},
		{
			{x=20,y=0,z=20},
			{x=0,y=0,z=20},
			{x=20,y=0,z=0}
		},
		{
			{x=0,y=20,z=0},
			{x=0,y=20,z=20},
			{x=20,y=20,z=0}
		},
		{
			{x=20,y=20,z=20},
			{x=0,y=20,z=20},
			{x=20,y=20,z=0}
		},
        -- {
        --     {x=math.cos(1)*15+xx,y=math.sin(1)*15+yy,z=0},
        --     {x=xx-math.cos(1)*15,y=yy-math.sin(1)*15,z=0},
        --     {x=xx-math.cos(1)*15,y=yy-math.sin(1)*15,z=-5}
        -- }

        {
            {x=0,y=0,z=20},
            {x=0,y=20,z=20},
            {x=20,y=0,z=20}
        },

		{
			{x=0,y=0,z=20},
			{x=0,y=0,z=0},
			{x=0,y=20,z=0}
		},
	}
	screen={w=400,h=400}
--[[	l={
		{1,2},
		{1,3},
		{2,4},
		{3,4}
	}]]--
	ol={}
	horizon=0
	moving=false
	wait=90
    rad = 20
    love.window.setMode(screen.w,screen.h)
    texture = love.graphics.newImage("texture.png")
    textureData = love.graphics.newImageData("texture.png")
end

function tri(x1,y1,x2,y2,x3,y3,c)
	local ux,uy=x2,y2
	local p=math.sqrt((x3-x2)^2+(y3-y2)^2)
	local sx=(x3-x2)/p
	local sy=(y3-y2)/p
	-- figure out steps
	-- local step=--area is 8*8.
	for i=1,p do
		love.graphics.line(x1,y1,ux+i*sx,uy+i*sy)
	end
	ux,uy=x1,y1
	p=math.sqrt((x3-x1)^2+(y3-y1)^2)
	sx=(x3-x1)/p
	sy=(y3-y1)/p
	for i=1,p do
		love.graphics.line(x2,y2,ux+i*sx,uy+i*sy)
	end
	ux,uy=x2,y2
	p=math.sqrt((x1-x2)^2+(y1-y2)^2)
	sx=(x1-x2)/p
	sy=(y1-y2)/p
	for i=1,p do
		love.graphics.line(x3,y3,ux+i*sx,uy+i*sy)
	end
end

function draw_textured_line(x1,y1,x2,y2,image,scale,ox,oy)
    local length = math.sqrt((x1-x2)^2 + (y1-y2)^2)
    local step_x = math.abs(x1-x2)/length
    local step_y = math.abs(y1-y2)/length
    for i=0,length do
        local r, g, b, a = image:getPixel(step_x*i, step_y*i)
        love.graphics.setColor(r,g,b)
        love.graphics.point(step_x*i*scale+ox,step_y*i*scale+oy)
    end
end

function sort(l)
	local prev=0
	for i=1,#l do
		for j=i+1,#l do
			if l[i][1]>l[j][1] then
				prev=l[j]
				l[j]=l[i]
				l[i]=prev
			end
		end
	end
	return l
end

function eqlst(l1,l2)
	if #l1==#l2 then
		for i=1,#l1 do
			if l1[i]~=l2[i] then
				return false
			end
		end
		return true
	end
	return false
end

function love.mousemoved( x, y, dx, dy, istouch )
	mx = dx
    my = dy
end

function love.draw()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill",0,0,screen.w,screen.h)
    love.graphics.setColor(0,0,0)
    -- love.graphics.print(p.z)

    pts = {}

    p.a = p.a - mx/1000
    p.va = p.va + my/1000
    mx = 0
    my = 0
    if love.keyboard.isDown("w") then
        p.x = p.x + math.sin(p.a*math.pi*2)
        p.y = p.y + math.cos(p.a*math.pi*2)
    end
    if love.keyboard.isDown("s") then
        p.x = p.x - math.sin(p.a*math.pi*2)
        p.y = p.y - math.cos(p.a*math.pi*2)
    end
    if love.keyboard.isDown("d") then
        p.x = p.x - math.sin((p.a+.25)*math.pi*2)
        p.y = p.y - math.cos((p.a+.25)*math.pi*2)
    end
    if love.keyboard.isDown("a") then
        p.x = p.x + math.sin((p.a+.25)*math.pi*2)
        p.y = p.y + math.cos((p.a+.25)*math.pi*2)
    end

    local pplane=make_cplane(p.x,p.y,p.a,rad/2,rad)
	local vplane=make_cplane(54,63+p.z,p.va,rad/2,rad)

	--[[ Clipping: Theory
		First, obtain all the points. If they are all offscreen, then ignore or don't add them!
		How to clip? Is a point offscreen? If so, draw a line from the edge of the pplane to the lines its on. Those are your new points.
	]]
	for i=1,#triangles do
		local t={}
		for j=1,3 do
            t[j] = do_intersect(pplane[1],pplane[2],pplane[3],pplane[4],triangles[i][j].x,triangles[i][j].y,p.x,p.y)

			t[j][6]=t[j][6]

			local pdist=math.sqrt((triangles[i][j].x-p.x)^2+(triangles[i][j].y-p.y)^2)

			local z1=do_intersect(vplane[1],vplane[2],vplane[3],vplane[4],--[[64,54-p.z,63,74-p.z,]]pdist+64,64+triangles[i][j].z,54,63)
			if not z1[1] then
				t[j][1] = false
			end

            t[j][4]=10-z1[6]
		end
		pts[#pts+1] = t
	end
	
	-- redo for triangle
	for i=1,#triangles do
		local pdist1=math.sqrt((triangles[i][1].x-p.x)^2+(triangles[i][1].y-p.y)^2+(triangles[i][1].z-p.z)^2)
		local pdist2=math.sqrt((triangles[i][2].x-p.x)^2+(triangles[i][2].y-p.y)^2+(triangles[i][2].z-p.z)^2)
		local pdist3=math.sqrt((triangles[i][3].x-p.x)^2+(triangles[i][3].y-p.y)^2+(triangles[i][3].z-p.z)^2)
		local pdist=pdist1+pdist2+pdist3/3
	
		ol[i]={pdist,i}
	end
	sort(ol)

    -- draw
	for i=#ol,1,-1 do
		local px=ol[i]
		local pt1=pts[px[2]][1]
		local pt2=pts[px[2]][2]
		local pt3=pts[px[2]][3]
        if pt1[1] and pt2[1] and pt3[1] then
            love.graphics.print("gone",0,20)
            --[[
            pt1[6]*6.4,pt1[4]*12.8
            pt2[6]*6.4,pt2[4]*12.8
            pt1[6]*6.4,pt1[5]*12.8
            pt2[6]*6.4,pt2[5]*12.8
            ]]--
            local pdist=px[1]

            love.graphics.setColor(20/pdist,20/pdist,20/pdist)

            triangle_function(pt1[6]*screen.w/rad,pt1[4]*screen.h/rad*2,pt2[6]*screen.w/rad,pt2[4]*screen.h/rad*2,pt3[6]*screen.w/rad,pt3[4]*screen.h/rad*2)
            ::skip::
        end
	end
end

init()