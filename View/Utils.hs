{-# LANGUAGE OverloadedStrings #-}
module View.Utils where

import Miso
import Miso.String (pack, unpack)
import qualified Miso.String as MS
import Data.List (intersperse, dropWhileEnd, groupBy)
import ProofTree
import Data.Char
import qualified Data.Map as M

axiomHeading i = div_ [class_ "axiomHeading"] [anchor i [text "Axiom."]]
theoremHeading i = div_ [class_ "theoremHeading"] [anchor i [text "Theorem."]]
metabinder v = span_ [ class_ "metabinder" ] (name v ++ [text "."])
context [] = span_ [ ] []
context v = span_ [class_ "context" ] v
space = span_ [class_ "space" ] [text " "] 
turnstile = span_ [class_ "turnstile" ] [text "⊢"] 
miniTurnstile = sub_ [class_ "mini"] [text "⊢"]
comma = span_ [class_ "comma" ] [text ","] 
placeholder = span_ [class_ "placeholder" ] [text "␣"] 
localrule i = span_ [ class_ "localrule" ] [text (pack (show i))]
renderRR (Defn d) = span_ [ class_ "definedrule" ] (name d)
renderRR (Local i) = localrule i
anchor i = a_ [id_ $ "anchor" <> pack (show i)]
button cls onClk = button_ [class_ cls, onClick onClk]
submitButton cls = button_ [class_ cls]
focusedButton cls onClk content = multi [button_ [class_ cls, id_ "focusedButton", onClick onClk ] content
                                , script_ [] "document.getElementById('focusedButton').focus();"]
focusHack i = script_ [] $ "document.getElementById('" <> i <> "').focus(); document.getElementById('" <> i <> "').select();"
typicon icn = span_ [class_ $ "typcn typcn-" <> icn] [] 
block cls is = div_ [class_ cls] is
inline cls is = span_ [class_ cls] is
multi = span_ []
labelledBrackets content label = multi [inline "labelbracket" [text "⟨"], content, inline "labelbracket" [text "⟩"], sup_ [] [ label ]]
parenthesise = ([inline "parens" [text "("]] ++) . (++ [inline "parens" [text ")"]])

expandingTextbox i act n = input_ [id_ i, style_ (M.singleton "width" (pack (show $ (((fromIntegral (MS.length n) + 1) *16) / 30)) <> "em")) , onInput act, value_ n]

inferrule binders premises spacer ruleTitle conclusion = 
   table_ [class_ "rulestep", intProp "cellpadding" 0, intProp "cellspacing" 0 ]
       [ tr_ [class_ "premises"] $
             [td_ [class_ "binderbox", rowspan_ "2"] binders]
          ++ map (td_ [class_ "premise"] . pure) premises
          ++ [td_ [class_ "spacer"] [spacer]]
          ++ [td_ [rowspan_ "2", class_ "rulebox"] [ruleTitle] ]
       , tr_ [] [td_ [class_ "conclusion",colspan_ (pack $ show $ length premises + 1)] conclusion]
       ]

name [] = []
name ('_':str) = placeholder : name str
name (' ':str) = name str
name str | (first, rest) <- span (`notElem` ("_ " :: [Char])) str = name' first ++ name rest

name' s = let noPrimes = dropWhileEnd (== '\'') s
              bulk = dropWhileEnd (isDigit) noPrimes
              rest = drop (length bulk) noPrimes
              bulk' = case bulk of 
                    "/\\" -> "∧"
                    "\\/" -> "∨"
                    "not" -> "¬"
                    "->"  -> "→"
                    "<-"  -> "←"
                    "<->" -> "↔"
                    "-->"  -> "⟶"
                    "<--"  -> "⟵ "
                    "<-->" -> "⟷"
                    "=>"  -> "⇒"
                    "<=="  -> "⇐"
                    "<=>" -> "⇔"
                    "<==>" -> "⟺"
                    "==>" -> "⟹"
                    "<===" -> "⟸"
                    "<-|"  -> "↤"
                    "=="   -> "≡"
                    "lub"  -> "⊓"
                    "glb"  -> "⊔"
                    "~="   -> "≃"
                    "~"    -> "∼"
                    "all"  -> "∀" 
                    "exists" -> "∃"
                    ":="   -> "≔"
                    "times"   -> "×"
                    "bot"   -> "⊥"
                    "top"   -> "⊤"
                    "infinity" -> "∞"
                    "[["  -> "〚"
                    "]]"  -> "〛"
                    "[<"  -> "〈"
                    ">]"  -> "〉"
                    ">>]"  -> "》"
                    "[<<"  -> "《"
                    "<="   -> "≤"
                    ">="   -> "≥"
                    "/="   -> "≠"
                    "|->" -> "↦"
                    "nat" -> "ℕ"
                    "rational" -> "ℚ"
                    "int" -> "ℤ"
                    "real" -> "ℝ"
                    "bool" -> "𝔹"
                    "product" -> "∏" 
                    "coproduct" -> "∐"  
                    "sum"       -> "∑"
                    "union" -> "∪"
                    "intersection" -> "∩"
                    "subseteq" -> "⊆"
                    "supseteq" -> "⊇"
                    "subset"   -> "⊂"
                    "supset"   -> "⊃"
                    "elem"     -> "∈"
                    "eval"     -> "⇓"
                    "alpha" -> "α"
                    "beta" -> "β"
                    "gamma" -> "γ"
                    "delta" -> "δ"
                    "epsilon" -> "ε"
                    "zeta" -> "ζ"
                    "eta" -> "η"
                    "theta" -> "θ"
                    "iota" -> "ι"
                    "kappa" -> "κ"
                    "lambda" -> "λ"
                    "varepsilon" -> "ϵ"
                    "mu" -> "μ"
                    "nu" -> "ν"
                    "xi" -> "ξ"
                    "pi" -> "π"
                    "rho" -> "ρ"
                    "sigma" -> "σ"
                    "varsigma" -> "ς"
                    "tau" -> "τ"
                    "phi" -> "φ"
                    "psi"-> "ψ"
                    "chi" -> "χ"
                    "omega" -> "ω"
                    "upsilon" -> "υ"
                    "Gamma" -> "Γ"
                    "Delta" -> "Δ"
                    "Theta" -> "Θ"
                    "Lambda" -> "Λ"
                    "Xi" -> "Ξ"
                    "Pi" -> "Π"
                    "Sigma" -> "Σ"
                    "Phi" -> "Φ"
                    "Psi"-> "Ψ"
                    "Omega" -> "Ω"
                    _ -> bulk
              primeString = makePrimeString (length s - length noPrimes)
              makePrimeString 0 = ""
              makePrimeString 1 = "′"
              makePrimeString 2 = "″"
              makePrimeString 3 = "‴"
              makePrimeString 4 = "⁗"
              makePrimeString n = "⁗" <> makePrimeString (n - 4)

           in if bulk' == "" then [text (pack rest)] else [text (pack bulk'), sub_ [] [text (pack rest)], text primeString ]             
