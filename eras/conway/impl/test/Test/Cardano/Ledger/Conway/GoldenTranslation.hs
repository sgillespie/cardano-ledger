{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}

-- | Deserializes `TranslationInstance`s from golden/translations.cbor file.
--
-- Each instance represents arguments passed to `ExtendedUTxO.txInfo` along with the produced result.
-- This test checks that calling `alonzoTxInfo` with the arguments from this file, produces the same result as in the flie.
--
-- To regenerate the golden file (for example, if the logic in the translation changes),
-- run the following command from the root of the repository:
-- cabal run cardano-ledger-<era>-test:gen-golden"
module Test.Cardano.Ledger.Conway.GoldenTranslation (
  spec,
)
where

import Cardano.Ledger.Conway (Conway)
import Paths_cardano_ledger_conway (getDataFileName)
import Test.Cardano.Ledger.Alonzo.Translation.Golden (assertTranslationResultsMatchGolden)
import Test.Cardano.Ledger.Common
import Test.Cardano.Ledger.Conway.Translation.TranslatableGen ()
import Test.HUnit (Assertion)

spec :: Spec
spec =
  describe "Golden translation tests" $
    it "golden/translation.cbor" $
      check "golden/translations.cbor"

check :: String -> Assertion
check file = assertTranslationResultsMatchGolden @Conway (getDataFileName file)
