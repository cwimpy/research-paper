// Research Paper Template for Typst via Quarto
// Enhanced academic template with Minion Pro body and Myriad Pro headings

#import "@preview/fontawesome:0.5.0": *

#let article(
  title: none,
  subtitle: none,
  authors: none,
  date: none,
  abstract: none,
  abstract-title: "Abstract",
  thanks: none,
  keywords: (),
  cols: 1,
  margin: (x: 1in, y: 1in),
  paper: "us-letter",
  lang: "en",
  region: "US",
  font: "Minion Pro",
  fontsize: 12pt,
  title-size: 16pt,
  subtitle-size: 14pt,
  heading-family: "Myriad Pro",
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  sectionnumbering: none,
  pagenumbering: "1",
  toc: false,
  toc_title: "Table of Contents",
  toc_depth: 3,
  toc_indent: 1.5em,
  doc,
) = {
  
  // Global page setup
  set page(
    paper: paper,
    margin: margin,
    numbering: pagenumbering,
    number-align: center,
  )
  
  // Text and paragraph settings
  set par(
    justify: true,
    leading: 0.65em,
    first-line-indent: 0.5in,
  )
  
  set text(
    lang: lang,
    region: region,
    font: font,
    size: fontsize,
  )
  
  // Heading settings
  set heading(numbering: sectionnumbering)
  
  show heading: it => {
    set par(first-line-indent: 0pt)
    
    if it.level == 1 {
      v(18pt)
      text(size: 14pt, weight: "bold", font: "Myriad Pro")[#it]
      v(12pt)
    } else if it.level == 2 {
      v(12pt)
      text(size: 13pt, weight: "bold", font: "Myriad Pro")[#it]
      v(8pt)
    } else if it.level == 3 {
      v(10pt)
      text(size: fontsize, style: "italic", weight: "bold", font: "Myriad Pro")[#it]
      v(6pt)
    } else {
      v(8pt)
      text(font: "Myriad Pro")[#it]
      v(4pt)
    }
  }
  
  // Title page with no page number
  if title != none {
    {
      set page(numbering: none)
      set par(first-line-indent: 0pt)
      
      // Title
      align(center)[
        #v(1in)
        #text(size: title-size, weight: "bold", font: "Myriad Pro")[
          #title
          #if thanks != none [
            // Include affiliations in the thanks footnote
            #let affil-text = if authors != none {
              let dagger-symbols = ("†", "‡", "§", "¶", "‖", "#")
              let affil-parts = ()
              
              for (i, author) in authors.enumerate() {
                if "affiliation" in author {
                  let symbol = dagger-symbols.at(i)
                  if "email" in author {
                    affil-parts.push(symbol + " " + author.affiliation + ". " + author.email)
                  } else {
                    affil-parts.push(symbol + " " + author.affiliation)
                  }
                }
              }
              
              thanks + "\n" + affil-parts.join("\n")
            } else {
              thanks
            }
            #footnote(affil-text, numbering: "*")
          ]
        ]
        
        #if subtitle != none {
          v(0.15in)
          text(size: subtitle-size, font: "Myriad Pro")[#subtitle]
        }
      ]
      
      // Authors side by side
      if authors != none {
        v(0.3in)
        let count = authors.len()
        let ncols = calc.min(count, 3)
        
        // Create dagger symbols for each author
        let dagger-symbols = ("†", "‡", "§", "¶", "‖", "#")
        
        grid(
          columns: (1fr,) * ncols,
          column-gutter: 1em,
          row-gutter: 0.8em,
          ..authors.enumerate().map(((i, author)) => 
            align(center)[
              #text(size: 12pt, weight: "bold")[
                #author.name
                #if "affiliation" in author [
                  #let symbol = dagger-symbols.at(i)
                  #super[#symbol]
                ]
                #if "orcid" in author [
                  #super[#link("https://orcid.org/" + repr(author.orcid).slice(1, -1))[
                    #text(fill: rgb("#A6CE39"))[#fa-orcid()]
                  ]]
                ]
              ]
            ]
          )
        )
      }
      
      // Date
      if date != none {
        v(0.25in)
        align(center)[
          #text(size: 12pt)[#date]
        ]
      }
      
      // Abstract on title page
      if abstract != none {
        v(0.25in)
        
        align(center)[
          #text(size: 12pt, weight: "bold", font: "Myriad Pro")[#abstract-title]
        ]
        
        v(6pt)
        
        block(inset: (left: 0.5in, right: 0.5in))[
          #set text(size: 9pt)
          #set par(first-line-indent: 0pt, justify: true, leading: 0.5em)
          #abstract
        ]
        
        // Keywords on title page  
        if keywords != none and keywords.len() > 0 {
          v(6pt)
          align(center)[
            #text(size: 9pt, weight: "bold")[Keywords: ]
            #text(size: 9pt)[#keywords.join(", ")]
          ]
        }
      }
      
      pagebreak()
    }
    
    // Reset page counter to 1 for main content
    counter(page).update(1)
  }
  
  // Table of Contents (if enabled)
  if toc {
    set par(first-line-indent: 0pt)
    
    align(center)[
      #text(size: 12pt, weight: "bold", font: "Myriad Pro")[#toc_title]
    ]
    
    v(12pt)
    
    outline(
      title: none,
      depth: toc_depth,
      indent: toc_indent
    )
    
    pagebreak()
  }
  
  // Main document content
  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}

// Enhanced table styling for academic papers
#set table(
  inset: 8pt,
  stroke: (x, y) => {
    if y == 0 { 
      (bottom: 1pt + black) 
    } else if y == 1 { 
      (bottom: 0.5pt + black) 
    } else { 
      none 
    }
  },
  align: left,
)

// Figure styling
#show figure: it => {
  set par(first-line-indent: 0pt)
  it
}

// Bibliography styling
#show bibliography: it => {
  set par(first-line-indent: 0pt, hanging-indent: 0.5in, spacing: 0.8em)
  it
}