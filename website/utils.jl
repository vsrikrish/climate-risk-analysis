using YAML
using Dates
using Weave

function hfun_bar(vname)
  val = Meta.parse(vname[1])
  return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end

function lx_baz(com, _)
  # keep this first line
  brace_content = Franklin.content(com.braces[1]) # input string
  # do whatever you want here
  return uppercase(brace_content)
end


function hw_badge(num)  
  link = "/assignments/hw$num/"
  alt_text = "HW$num Instructions"
  badge_right = "HW$num Assignment"
  badge_left = "Web"
  badge_url = "https://img.shields.io/static/v1?label=$badge_left&message=$badge_right&color=b31b1b&labelColor=222222&style=flat"
  badge_string = "[![$alt_text]($badge_url)]($link)"
  return badge_string
end

function rubric_badge(num)  
  link = "/assignments/hw$num/rubric/"
  alt_text = "HW$num Rubric"
  badge_right = "HW$num Rubric"
  badge_left = "Web"
  badge_url = "https://img.shields.io/static/v1?label=$badge_left&message=$badge_right&color=b31b1b&labelColor=222222&style=flat"
  badge_string = "[![$alt_text]($badge_url)]($link)"
  return badge_string
end

function solution_badge(num)  
  link = "/assignments/hw$num/solution/"
  alt_text = "HW$num Solution"
  badge_right = "HW$num Solution"
  badge_left = "Web"
  badge_url = "https://img.shields.io/static/v1?label=$badge_left&message=$badge_right&color=b31b1b&labelColor=222222&style=flat"
  badge_string = "[![$alt_text]($badge_url)]($link)"
  return badge_string
end

function hfun_hw_badges(params) 
  num = params[1]
  io = IOBuffer()
  write(io, Franklin.fd2html("""
    @@badges
    $(hw_badge(num))
    @@
    """, internal=true)
  )
  return String(take!(io))
end

function hfun_rubric_badges(params) 
  num = params[1]
  io = IOBuffer()
  write(io, Franklin.fd2html("""
    @@badges
    $(rubric_badge(num))
    @@
    """, internal=true)
  )
  return String(take!(io))
end

function hfun_solution_badges(params) 
  num = params[1]
  io = IOBuffer()
  write(io, Franklin.fd2html("""
    @@badges
    $(solution_badge(num))
    @@
    """, internal=true)
  )
  return String(take!(io))
end

function lecture_badge(num)  
  path_names = filter(isdir, readdir("lecture-notes"; join=true))
  lecture_path = filter(x -> contains(x, num), path_names)
  name = split(lecture_path[1], "-")[3]
  link = string("/", strip(lecture_path[1], '_'), "/index.html")
  alt_text = string(titlecase(name), " Notes")
  badge_url = "https://img.shields.io/static/v1?label=Web&message=Lecture%20$num&color=b31b1b&labelColor=222222&style=flat"
  badge_string = "[![$alt_text]($badge_url)]($link)"
  return badge_string
end


function hfun_lecture_badges(params::Vector{String}) 
  name = params[1]
  io = IOBuffer()
  write(io, Franklin.fd2html("""
    @@badges
    $(lecture_badge(name))
    @@
    """, internal=true)
  )
  return String(take!(io))
end

function lab_badge(num)  
  link = "https://github.com/ClimateRiskAnalysis/lab$num"
  alt_text = "Lab $num"
  badge_url = "https://img.shields.io/static/v1?label=Repository&logo=github&message=Lab%20$num&color=b31b1b&labelColor=222222&style=flat"
  badge_string = "[![$alt_text]($badge_url)]($link)"
  return badge_string
end


function hfun_lab_badges(params::Vector{String}) 
  name = params[1]
  io = IOBuffer()
  write(io, Franklin.fd2html("""
    @@badges
    $(lab_badge(name))
    @@
    """, internal=true)
  )
  return String(take!(io))
end

function project_badge(nm, ftype)  
  if ftype == "html"
    link = string("/assignments/", nm, "/$nm/")
    alt_text = string("Project", titlecase(nm), " Instructions")
    badge_right = "web"
  elseif ftype == "pdf"
    link = string("/assignments/", nm, "/$nm.pdf")
    alt_text = string("Project", titlecase(nm), " Instructions")
    badge_right = "pdf"
  end
  badge_left = "project"
  badge_url = "https://img.shields.io/static/v1?label=$badge_left&message=$badge_right&color=b31b1b&labelColor=222222&style=flat"
  badge_string = "[![$alt_text]($badge_url)]($link)"
  return badge_string
end

function hfun_project_badges(params) 
  nm = params[1]
  io = IOBuffer()
  write(io, Franklin.fd2html("""
    @@badges
    $(project_badge(nm, "html"))
    $(project_badge(nm, "pdf"))
    @@
    """, internal=true)
  )
  return String(take!(io))
end


function hfun_day_schedule(params::Vector{String})
  path_to_yml = params[1]
  dname = params[2]
  sched = YAML.load_file(path_to_yml)["schedule"]
  d = filter(kv -> kv["name"] == dname, sched)[1]
  if haskey(d, "events")
    events = d["events"]
    # write the list
    io = IOBuffer()
    write(io, """<ul class="schedule-events" style="height: 790px">\n""")
    for event in events
      (name, location, start, finish) = values(event)
      if startswith(name, "Office Hours")
        slug = "office-hours"
      else
        slug = lowercase(name)
        replace(slug, " " => "-")
      end
      top = string(Int(round(Minute(Time(start, "II:MM p") - Time(8)).value * 4/3)), "px")
      height = string(Int(round(Minute(Time(finish, "II:MM p") - Time(start, "II:MM p")).value * 4/3)), "px")
      write(io, """<li class="schedule-event $slug" style="top: $top; height: $height">\n""")
      write(io, """<div class="name">$name</div>\n""")
      write(io, """<div class="time">$start-$finish</div>\n""")
      write(io, """<div class="location">$location</div>\n""")
      write(io, "</li>\n")
    end
    write(io, "</ul>\n")

    out = String(take!(io))
  else
    out = "\n"
  end
  return out
end

function hfun_insert_weave(params)
  rpath = params[1]
  fullpath = joinpath(Franklin.path(:folder), rpath)
  (isfile(fullpath) && splitext(fullpath)[2] == ".jmd") || return ""
  print("Weaving... ")
  t = tempname()
  weave(fullpath, out_path=t)
  println("✓ [done].")
  fn = splitext(splitpath(fullpath)[end])[1]
  html = read(joinpath(t, fn * ".html"), String)
  start = findfirst("<BODY>", html)
  finish = findfirst("</BODY>", html)
  range = nextind(html, last(start)):prevind(html, first(finish))
  html = html[range]
  return html
end