require './app.scss'

lightModel = new Vue({
	el: '#lightView'
	data:
		brightness: 50
		state: 'rest' # rest, transition, observation
		updated: null
		timeoutHandle: null
	methods:
		receive: (value) ->
			that = this
			_.delay((-> that.update(value)), 500) # call update method after 500 ms
		send: ->
			that = this
			lightBulb.receive(that.brightness)
		switchTransition: ->
			this.state = 'transition'
			clearTimeout(this.timeoutHandle)
		switchObservation: ->
			this.state = 'observation'
			# after 2 seconds, switch state to rest and update
			this.timeoutHandle = setTimeout((-> 
				that.state = 'rest'
				lightBulb.send()), 2000)
		update: (value) -> # 
			that = this
			switch that.state
				when 'rest' then that.brightness = value
				when 'observation' # reset timer on receiving a value
					clearTimeout(this.timeoutHandle)
					that.timeoutHandle = setTimeout((-> 
						that.state = 'rest'
						lightBulb.send()), 2000)
				else break
			that.updated = value
})

otherDevice = new Vue({
	el: '#otherDevice'
	data:
		brightness: null
	methods:
		send: ->
			that = this
			lightBulb.receive(that.brightness)
})

lightBulb = new Vue({
	el: '#lightBulb'
	data:
		brightness: 50
	methods:
		receive: (value) ->
			that = this
			_.delay((-> 
				that.brightness = value
				that.send()),
				500)
		send: ->
			that = this
			lightModel.receive(that.brightness)
})