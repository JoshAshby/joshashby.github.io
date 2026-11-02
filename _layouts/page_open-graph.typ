#let title = sys.inputs.at("title")
#let subtitle = sys.inputs.at("subtitle", default: "")
#let date = sys.inputs.at("date", default: "")
#let tags = sys.inputs.at("tags", default: "").split(",").filter(x => x.len() != 0)

#let recoloredSvg(path, colors: ()) = {
  let svg = read(path)

  for (old, new) in colors {
    svg = svg.replace(old, new)
  }

  bytes(svg)
}

#set page(
  width: 1200pt,
  height: 630pt,
  margin: 0pt,
  fill: rgb("#001923"),
  background: {
    place(
      center + horizon,
      image(recoloredSvg("/assets/icons/topography.svg", colors: ("#000": eastern.darken(65%).to-hex())), width: 100%),
    )
    place(
      bottom + left,
      rect(width: 100%, height: 150pt, fill: luma(20%, 75%))
    )
  }
)
#set text(fill: white)

#show heading.where(level: 1): set text(font: "IBM Plex Sans", size: 60pt, weight: 800)
#show heading.where(level: 2): set text(font: "IBM Plex Sans", size: 40pt, weight: 500)
#show heading.where(level: 6): set text(font: "Scientifica", size: 50pt, weight: 700)

#let pill(content, color: gray) = {
  box(radius: 100%, stroke: color)[
    #pad(y: 8pt, x: 12pt)[
      #align(horizon)[
        #text(font: "IBM Plex Sans", size: 20pt, content)
      ]
    ]
  ]
}

#grid(
  rows: (1fr, 150pt),
  columns: (1fr, auto),
  inset: 50pt,

  grid.cell(
    colspan: 2,
    align(left + horizon)[= #title]
  ),

  grid(rows: (1fr, 1fr))[
    == #date
    #if tags.len() != 0 [
      #stack(dir: ltr)[
        #for tag in tags [ #pill(tag) ]
      ]
    ]
  ],

  align(right + horizon)[====== Josh Ashby]
)
