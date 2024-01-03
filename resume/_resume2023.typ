#{
  let primary_color = rgb("#154c79")

  let resume = yaml("/_data/resume.yml")

  set document(
    title: resume.whoami + "'s Resume",
    author: resume.whoami,
  )

  set page(
   "us-letter",
    margin: (x: 54pt, y: 52pt),

  // Sets the page header to the last level 2 header followed by " (Continued)"
    header: locate(loc => {
      let elems = query(
        selector(heading.where(level: 2)).before(loc),
        loc,
      )

      if elems != () {
        let body = elems.last().body
        heading(level: 2, body + " (Continued)")
      }
    })
  )

  set text(9.8pt, font: "IBM Plex Sans")

  show heading.where(level: 1): it => text(
    fill: primary_color,
    it.body
  )

  show heading.where(level: 3): it => text(
    fill: primary_color,
    it.body
  )

  let icon(name, shift: 1.5pt, height: 10pt, left: 1pt) = {
    box(
      baseline: shift,
      height: height,
      image("/assets/icons/" + name + ".svg")
    )
    h(left)
  }

  [
    #stack(
      dir: ltr,
      align(start + horizon)[= #resume.whoami],
      align(end, grid(
        columns: 2,
        gutter: 10pt,
        "",
        link(resume.contactPoints.email.link)[#icon("mail") #resume.contactPoints.email.text],
        link(resume.contactPoints.website.link)[#icon("link-2") #resume.contactPoints.website.text],
        link(resume.contactPoints.github.link)[#icon("github") #resume.contactPoints.github.text]
      ))
    )

    #line(length: 100%, stroke: 1pt + primary_color)

    #resume.aboutMe \
    *Primary Technologies:* #resume.primaryTechnologies.join(", ")
    *Comfortable Tools & Platforms:* #resume.primaryTools.join(", ")

    == Notable Work
    #list(..resume.notableWork)

    == Professional Experience

    #for job in resume.workExperience [
      #block(
        breakable: false,
        [
          #v(7pt)
          #grid(
            columns: (1fr, auto),
            stack(
              dir: ttb, spacing: 5pt,
              [
                === #job.role
                #text(7pt, smallcaps(job.at("hats", default: ()).join(" / ")))
              ],
              text(9pt)[#icon("calendar", height: 9pt) #eval(job.duration, mode: "markup")]
            ),
            align(end, stack(
              dir: ttb, spacing: 5pt,
              text(10pt, style: "oblique")[
                #if job.at("link", default: none) != none [
                  #link(job.link)[#job.company]
                ] else [
                  #job.company
                ]
              ],
              text(8pt)[#icon("map-pin", height: 8pt) #job.location],
            ))
          )
          #v(3pt)
          #list(..job.highlights)
        ]
      )
    ]
  ]
}
