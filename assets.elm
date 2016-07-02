module Assets exposing (images)
import List exposing (map)

assets = 
    [ "trayvonmartin.jpg"
    , "tanisha.jpg"
    , "rsz_tamir-rice.jpg"
    , "rsz_1sandra-bland-linkedin.jpg"
    , "mike-brown-headshot-smaller.jpg"
    , "rsz_john-crawford-iii.jpg"
    , "rsz_eric_garner_facebook.jpg"
    , "dontre-hamilton.jpg"
    ]

images = map (\asset -> "img/" ++ asset) assets