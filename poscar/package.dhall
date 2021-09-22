let concatMapSep =
      https://prelude.dhall-lang.org/v20.2.0/Text/concatMapSep.dhall
        sha256:c272aca80a607bc5963d1fcb38819e7e0d3e72ac4d02b1183b1afb6a91340840

let concatSep =
      https://prelude.dhall-lang.org/v20.2.0/Text/concatSep.dhall
        sha256:e4401d69918c61b92a4c0288f7d60a6560ca99726138ed8ebc58dca2cd205e58

let map =
      https://prelude.dhall-lang.org/v20.2.0/List/map.dhall
        sha256:dd845ffb4568d40327f2a817eb42d1c6138b929ca758d50bc33112ef3c885680

let Mode = < Cartesian | Direct >

let Elements = ./elements.dhall

let Atom
    : Type
    = { element : Text, size : Natural, coordinates : List (List Double) }

let Poscar =
      { name : Text
      , constant : Double
      , mode : Mode
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
            let render-atom-coordinates =
                  λ(a : Atom) → render-list-list-double a.coordinates

            let atom-coordinates =
                  λ(xs : List Atom) →
                    let lines = map Atom Text render-atom-coordinates xs

                    in  concatSep "\n" lines

            in  ''
                ${p.name}
                ${Double/show p.constant}
                ${render-list-list-double p.basis}
                ${render-atoms p.atoms}
                ${render-mode p.mode}
                ${atom-coordinates p.atoms}
                ''

in  { Mode, show, Poscar, Elements }
