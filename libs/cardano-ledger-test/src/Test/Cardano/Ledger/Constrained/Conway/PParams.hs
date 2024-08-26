{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}

-- | Mostly for backward compatibility as many modules import
--   this one to get 'pparamsSpec'
module Test.Cardano.Ledger.Constrained.Conway.PParams where

import Cardano.Ledger.Conway.Core
import Constrained
import Test.Cardano.Ledger.Constrained.Conway.Instances (
  EraPP (..),
  simplePParamsSpec,
 )

pparamsSpec :: forall fn era. (EraPP era, BaseUniverse fn) => Specification fn (PParams era)
pparamsSpec = constrained' $ \simplepp -> satisfies simplepp (simplePParamsSpec @fn @era)
