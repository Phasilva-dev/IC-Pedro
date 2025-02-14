struct LeaveReturnTimes
	leaveTime::NormalDistParams
	returnTime::NormalDistParams
end

struct RoutineProfile
	wakeUpTime::NormalDistParams
	sleepTime::NormalDistParams
	leaveReturnTimes::Union{Nothing, Vector{LeaveReturnTimes}}  # Pode ser `nothing` se não houver eventos

	function TimeProfile(wakeUpTime::NormalDistParams, sleepTime::NormalDistParams,
		leaveReturnTimes::Union{Nothing, Vector{LeaveReturnTimes}} = nothing)
		return new(wakeUpTime, sleepTime, leaveReturnTimes)
	end
end