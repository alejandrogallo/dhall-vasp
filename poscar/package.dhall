let concatMapSep =
      https://prelude.dhall-lang.org/v20.2.0/Text/concatMapSep.dhall
        sha256:c272aca80a607bc5963d1fcb38819e7e0d3e72ac4d02b1183b1afb6a91340840

let Mode = < Cartesian | Direct >

let Elements = ./elements.dhall

let Atom
    : Type
    = { element : Text, size : Natural }

let Poscar =
      { name : Text
      , constant : Double
      , mode : Mode
      , coordinates : List (List Double)
      , basis : List (List Double)
      , atoms : List Atom
      }

let show =
      let render-list-list-double =
            let render-list-double = concatMapSep " " Double Double/show

            in  concatMapSep "\n" (List Double) render-list-double

      let render-mode =
            λ(m : Mode) → merge { Cartesian = "Cartesian", Direct = "Direct" } m

      let render-atoms =
            λ(xs : List Atom) →
              ''
              ${concatMapSep " " Atom (λ(at : Atom) → at.element) xs}
              ${concatMapSep
                  " "
                  Atom
                  (λ(at : Atom) → Natural/show at.size)
                  xs}''

      in  λ(p : Poscar) →
            ''
            ${p.name}
            ${Double/show p.constant}
            ${render-list-list-double p.basis}
            ${render-atoms p.atoms}
            ${render-mode p.mode}
            ${render-list-list-double p.coordinates}
            ''

in  { Mode, show, Poscar, Elements }
