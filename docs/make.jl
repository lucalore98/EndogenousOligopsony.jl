using EndogenousOligopsony
using Documenter

DocMeta.setdocmeta!(EndogenousOligopsony, :DocTestSetup, :(using EndogenousOligopsony); recursive=true)

makedocs(;
    modules=[EndogenousOligopsony],
    authors="Luca Lorenzini",
    sitename="EndogenousOligopsony.jl",
    format=Documenter.HTML(;
        canonical="https://lucalore98.github.io/EndogenousOligopsony.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/lucalore98/EndogenousOligopsony.jl",
    devbranch="master",
)
