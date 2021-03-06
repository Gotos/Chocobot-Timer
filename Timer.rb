# encoding: utf-8
require_relative './Models/TimedEvent.rb'

class Timer

	PluginLoader.registerPlugin("Timer", self)

	attr_accessor :run, :messager

	def self.getInstance(messager = nil, logger = nil)
		if @instance == nil
			@instance = Timer.new(messager, logger)
		end
		return @instance
	end

	def initialize(messager, logger)
		@messager = messager
		@msgCount = 0
		@time = 0
		@run = true

		TimedEvent.all.each do |timerEvent|
			timerEvent.t = 0
			timerEvent.mc = 0
			timerEvent.save
		end

		Thread.new do
			while @run
				TimedEvent.all.each do |timerEvent|
					if timerEvent.time + timerEvent.t <= @time
						timerEvent.t = @time
						if timerEvent.messagesPassed + timerEvent.mc <= @msgCount
							timerEvent.mc = @msgCount
							messager.message(timerEvent.msg) if timerEvent.active
						end
					end
					timerEvent.save
				end
				sleep(60)
				@time += 1
			end
		end
	end

	def add(name, msg, time, messagesPassed)
		TimedEvent.create(:name => name, :msg => msg, :time => time, :messagesPassed => messagesPassed, :t => @time, :mc => @msgCount)
	end

	def remove(name)
		entry = TimedEvent.get(name)
		entry.destroy() if entry != nil
	end

	def newMsg(msg)
		@msgCount += 1
	end

	def timerList()
		names = []
		TimedEvent.all.each do |timerEvent|
			names << timerEvent.name
		end
		return names
	end

	def self.addPlugin()
		PluginLoader.addNewMsg(self)
		PluginLoader.addCommand(Command.new("!addtimer", lambda do |data, priv, user|
			if priv <= 10
				getInstance.add(data[0], data[3..-1].join(" "), data[1].to_i, data[2].to_i)
				getInstance.messager.message("Timer " + data[0] + " wurde gesetzt mit dem Zeitintervall " + data[1].to_i.to_s + " Minute(n) und dem Nachrichtenintervall " + data[2].to_i.to_s + ".")
				return true
			end
			return false
		end))
		PluginLoader.addCommand(Command.new("!deltimer", lambda do |data, priv, user|
			if priv <= 10
				getInstance.remove(data[0])
				getInstance.messager.message("Timer " + data[0] + " wurde entfernt.")
				return true
			end
			return false
		end))
		PluginLoader.addCommand(Command.new("!listtimer", lambda do |data, priv, user|
			if priv <= 10
				getInstance.messager.message("Folgende Timer sind installiert: " + getInstance.timerList().join(" "))
				return true
			end
			return false
		end))
		PluginLoader.addCommand(Command.new("!testtimer", lambda do |data, priv, user|
			if priv <= 10
				getInstance.messager.message(TimedEvent.get(data[0]).msg)
				return true
			end
			return false
		end))
		PluginLoader.addCommand(Command.new("!stoptimer", lambda do |data, priv, user|
			if priv <= 10
				timerEvent = TimedEvent.get(data[0])
				timerEvent.active = false
				timerEvent.save
				getInstance.messager.message("Timer " + data[0] + " gestoppt.")
				return true
			end
			return false
		end))
		PluginLoader.addCommand(Command.new("!starttimer", lambda do |data, priv, user|
			if priv <= 10
				timerEvent = TimedEvent.get(data[0])
				timerEvent.active = true
				timerEvent.save
				getInstance.messager.message("Timer " + data[0] + " gestartet.")
				return true
			end
			return false
		end))
	end
end
