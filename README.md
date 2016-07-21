This repository contains the keys of the hackage root key holders.

This is primarily to help us keep track, but it also serves the purpose of
letting 3rd parties verify that the root keys are indeed held by the people
who ought to hold them.


Verifying root keys
=====================

Several of the root key holders have sent a gpg-signed email that confirms
the public part of the hackage root key that they hold, and that they
understand their responsibilities as a hackage root key holder.

So anyone can verify the root key set by:

 1. Reading each of these emails, checking that the public key mentioned in
    the email corresponds to the one in the hackage root metadata file
    (`root.json`).
 2. Using gpg to verify that the emails were sent by the correct people.
    This requires that you have previously joined the gpg web of trust
    involving the hackage root key holders.


Note that some of the emails use detached signatures and some use inline
signatures. Where there is just a `.email` file and no `.sig` use
`gpg --verify $name.email`, where there is a separate `.sig` then use
`gpg --verify $name.sig $name.email`

So you can check the current signatures like so:

    $ gpg --verify adam-gundry.email.sig adam-gundry.email
    $ gpg --verify gershom-bazerman.email.sig gershom-bazerman.email
    $ gpg --verify johan-tibell.email
    $ gpg --verify john-wiegley.email.sig john-wiegley.email 
    $ gpg --verify norman-ramsey.email

