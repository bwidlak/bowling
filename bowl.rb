class Frame

	def initialize
		@first_throw = 0
		@second_throw = 0
		@frame_tracker = 0
		@status = :normal
		@bonus = false
	end

	def add(pins, status, bonus)
		if @frame_tracker == 0
			@first_throw = pins
		elsif @frame_tracker == 1
			@second_throw = pins
		end
		@status = status if !status.nil?
		@bonus = bonus if !bonus.nil?

		@frame_tracker += 1
	end

	def frame_status
		@status
	end

	def finished?
		@frame_tracker == 2 || @first_throw == 10
	end

	def count_throws
		@frame_tracker
	end

	def first_throw
		@first_throw
	end

	def second_throw
		@second_throw
	end

	def bonus
		@bonus
	end

end

class Game

	def initialize
		@frames = []
		@bonus = 0
	end

	def roll number

		frame = current_frame

		if number == 10 && frame.count_throws == 0
			status = :strike
		elsif frame.count_throws == 1 && (frame.first_throw + number) == 10
			status = :spare
		end

		if @bonus == 1
			bonus = true
			number = 0 if (@frames[@frames.index(@frames.last) - 1 ].frame_status == :spare && @frames.last.bonus == true) || (@frames[@frames.index(@frames.last) - 1 ].frame_status == :strike && @frames.last.bonus == true && number == 10)
		end

		frame.add number, status, bonus
		bonus_throws
		number
	end

	def score
		sc = 0
		@frames.each do |frame|
			if @frames.index(frame) == 0
				sc += frame.first_throw + frame.second_throw
			else
				if @frames[@frames.index(frame) - 1 ].frame_status == :strike
					sc += 2*(frame.first_throw + frame.second_throw)
				elsif @frames[@frames.index(frame) - 1 ].frame_status == :spare
					sc += 2*frame.first_throw + frame.second_throw
				else
					sc += frame.first_throw + frame.second_throw
				end
			end
			puts "Frame #{@frames.index(frame) + 1}"
			puts "1st:            #{frame.first_throw}"
			puts "2nd:            #{frame.second_throw}"
			puts "status:         #{frame.frame_status}"
			puts "close frame with: #{sc} #{sc == 1 ? 'point' : 'points'}"
			puts "================"
		end
		puts "Total:  #{sc}"

	end

	def bonus_throws
		@bonus = 1 if @frames.count == 10 && (@frames.last.frame_status == :strike || @frames.last.frame_status == :spare)
	end

	private

		def current_frame
			if (@frames.empty? || @frames.last.finished?) && @frames.count < (10 + @bonus) # as we have 10 frames
				@frames << Frame.new
			end
			@frames.last
		end
end