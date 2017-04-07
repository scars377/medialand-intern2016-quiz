express = require 'express'
app = express()
server = app.listen 3000,->console.log 'server started'

app.use express.static 'client'


io = require('socket.io')(server)

num = 0
newQuestion = ->
	num = Math.random()*0xffffff|0
	io.emit 'question', num
setInterval newQuestion, 1000

checkAnswer = (n)->
	ans = parseInt n,10
	a = num&0xff
	b = '+-*'[(num>>8)%3]
	c = num>>10&0xff
	return ans is eval a+b+c

io.on 'connect',(socket)->
	socket.emit 'question', num
	socket.on 'answer',(n)->
		if checkAnswer n
			socket.emit 'answered',{correct:true, url:'0x2537.html'}
		else
			socket.emit 'answered',{correct:false, ans:n}
