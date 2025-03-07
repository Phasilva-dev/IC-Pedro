using PackageCompiler

create_app(
    ".",
    "compiled_app";
    precompile_execution_file=["src/teste.jl"],
    force=true,
    include_lazy_artifacts=true
)

create_app(
    ".",
    "compiled_app";
    precompile_execution_file=["src/teste.jl"],
    force=true,
    include_lazy_artifacts=true,
    # Flags críticas para redução de memória:
    cpu_target="generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)",  # Compatibilidade ampla
    filter_stdlibs=true,               # Remove stdlibs não usadas
    sysimage_build_args=`--heap-size-hint=2G`,  # Limite de memória (ajuste conforme necessário)
    incremental=false                  # Se falhar, tente `incremental=true`
)