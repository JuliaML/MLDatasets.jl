
#temporary to not stress CI
if !parse(Bool, get(ENV, "CI", "false"))
    @testset "PTBLM" begin
        x, y = PTBLM.traindata()
        x, y = PTBLM.testdata()
    
    end
    @testset "UD_English" begin
        x = UD_English.traindata()
        x = UD_English.devdata()
        x = UD_English.testdata()
    end
end