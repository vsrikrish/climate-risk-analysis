using Literate
import Base.(/)
(/)(ps...) = joinpath(ps...)

tut_nbpath = joinpath("tutorials", "notebooks")
isdir(tut_nbpath) || mkpath(tut_nbpath)

function gen_notebooks(genpath, sourcepath)
   for dir in readdir(sourcepath)
      
      script   = sourcepath/dir/"tutorial.jl"
      project  = sourcepath/dir/"Project.toml"
      manifest = sourcepath/dir/"Manifest.toml"

      path = genpath/dir
      isdir(path) || mkpath(path)

      Literate.notebook(script, path, name=dir, credit=false, execute=false, mdstrings=true)
      isfile(project) && cp(project,  path/"Project.toml", force=true)
      isfile(manifest) && cp(manifest, path/"Manifest.toml", force=true)
   end
end

gen_notebooks(tut_nbpath, "_literate")