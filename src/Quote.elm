module Quote exposing (Quote, defaultQuote, quotes, randomQuote)

import Array exposing (Array, fromList, get)
import Random


type alias Quote =
    { text : String
    , author : String
    }


randomQuote : (Quote -> msg) -> Cmd msg
randomQuote msg =
    Random.generate
        (\i ->
            case get i quotes of
                Just quote ->
                    msg quote

                Nothing ->
                    msg defaultQuote
        )
        (Random.int 0 (Array.length quotes - 1))


defaultQuote : Quote
defaultQuote =
    { text = "Be yourself; everyone else is already taken."
    , author = "— Oscar Wilde"
    }


quotes : Array Quote
quotes =
    fromList
        [ defaultQuote
        , { text = "The only way to do great work is to love what you do."
          , author = "— Steve Jobs"
          }
        , { text = "Believe you can and you're halfway there."
          , author = "— Theodore Roosevelt"
          }
        , { text = "Your time is limited, don't waste it living someone else's life."
          , author = "— Steve Jobs"
          }
        , { text = "Strive not to be a success, but rather to be of value."
          , author = "— Albert Einstein"
          }
        , { text = "The future belongs to those who believe in the beauty of their dreams."
          , author = "— Eleanor Roosevelt"
          }
        , { text = "Do what you feel in your heart to be right – for you’ll be criticized anyway"
          , author = "— Eleanor Roosevelt"
          }
        , { text = "Peace begins with a smile"
          , author = "— Mother Teresa"
          }
        , { text = "I don't know why we are here, but I'm pretty sure that it is not in order to enjoy ourselves."
          , author = "— Ludwig Wittgenstein"
          }
        , { text = "Success is not final, failure is not fatal: It is the courage to continue that counts."
          , author = "— Winston Churchill"
          }
        , { text = "Don't watch the clock; do what it does. Keep going."
          , author = "— Sam Levenson"
          }
        , { text = "In the middle of every difficulty lies opportunity."
          , author = "— Albert Einstein"
          }
        , { text = "The only limit to our realization of tomorrow will be our doubts of today."
          , author = "— Franklin D. Roosevelt"
          }
        , { text = "It's not whether you get knocked down, it's whether you get up."
          , author = "— Vince Lombardi"
          }
        , { text = "The only person you are destined to become is the person you decide to be."
          , author = "— Ralph Waldo Emerson"
          }
        , { text = "Don't be pushed around by the fears in your mind. Be led by the dreams in your heart."
          , author = "— Roy T. Bennett"
          }
        , { text = "Success is stumbling from failure to failure with no loss of enthusiasm."
          , author = "— Winston S. Churchill"
          }
        , { text = "What lies behind us and what lies before us are tiny matters compared to what lies within us."
          , author = "— Ralph Waldo Emerson"
          }
        , { text = "The only way to achieve the impossible is to believe it is possible."
          , author = "— Charles Kingsleigh"
          }
        , { text = "Your life does not get better by chance, it gets better by change."
          , author = "— Jim Rohn"
          }
        , { text = "The best way to predict the future is to create it."
          , author = "— Peter Drucker"
          }
        , { text = "Do not wait to strike till the iron is hot, but make it hot by striking."
          , author = "— William Butler Yeats"
          }
        , { text = "Success is not in what you have, but who you are."
          , author = "— Bo Bennett"
          }
        , { text = "The only limit to our realization of tomorrow will be our doubts of today."
          , author = "— Franklin D. Roosevelt"
          }
        , { text = "It always seems impossible until it’s done."
          , author = "— Nelson Mandela"
          }
        , { text = "The harder I work, the luckier I get."
          , author = "— Gary Player"
          }
        , { text = "Believe in yourself and all that you are. Know that there is something inside you that is greater than any obstacle."
          , author = "— Christian D. Larson"
          }
        , { text = "You are never too old to set another goal or to dream a new dream."
          , author = "— C.S. Lewis"
          }
        , { text = "The only limit to our realization of tomorrow will be our doubts of today."
          , author = "— Franklin D. Roosevelt"
          }
        , { text = "The only way to achieve the impossible is to believe it is possible."
          , author = "— Charles Kingsleigh"
          }
        , { text = "Your time is limited, don't waste it living someone else's life."
          , author = "— Steve Jobs"
          }
        , { text = "The best way to predict the future is to create it."
          , author = "— Peter Drucker"
          }
        , { text = "Success is not in what you have, but who you are."
          , author = "— Bo Bennett"
          }
        , { text = "The only person you are destined to become is the person you decide to be."
          , author = "— Ralph Waldo Emerson"
          }
        , { text = "Don't be pushed around by the fears in your mind. Be led by the dreams in your heart."
          , author = "— Roy T. Bennett"
          }
        , { text = "You may not control all the events that happen to you, but you can decide not to be reduced by them."
          , author = "— Maya Angelou"
          }
        , { text = "If you don’t like the road you’re walking, start paving another one."
          , author = "— Dolly Parton"
          }
        , { text = "When one door of happiness closes, another opens; but often we look so long at the closed door that we do not see the one which has been opened for us."
          , author = "— Helen Keller"
          }
        , { text = "It's the possibility of having a dream come true that makes life interesting"
          , author = "— Paulo Coelho"
          }
        ]
