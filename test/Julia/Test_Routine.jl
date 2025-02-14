using Test

# Teste para a struct LeaveReturnTimes
@testset "LeaveReturnTimes Tests" begin
    # Criação de uma instância de LeaveReturnTimes
    leaveTime = NormalDistParams(8 * 3600, 3600)  # 8:00 com desvio padrão de 1 hora
    returnTime = NormalDistParams(18 * 3600, 3600)  # 18:00 com desvio padrão de 1 hora
    leave_return = LeaveReturnTimes(leaveTime, returnTime)
    
    # Testes de assertiva
    @test leave_return.leaveTime.mean == 8 * 3600
    @test leave_return.leaveTime.std == 3600
    @test leave_return.returnTime.mean == 18 * 3600
    @test leave_return.returnTime.std == 3600
end
