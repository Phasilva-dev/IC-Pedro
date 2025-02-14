using Pkg
#Pkg.status()
Pkg.activate(".")  # Ativar o ambiente
Pkg.resolve()      # Resolver possíveis conflitos
#Pkg.instantiate()  # Baixar dependências faltantes
Pkg.status()
pwd()
