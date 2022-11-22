$suits = 'Clubs','Diamonds','Hearts','Spades'
$ranks = 'Ace','2','3','4','5','6','7','8','9','10','Jack','Queen','King'

# ALL variables for the PLAYER go here
[int]$global:PlayerScore = 0
[array]$global:PlayerHand = $null
$global:Winnings = 5

# ALL variables for ??? go here
[array]$global:DealerHand = $null
[int]$global:DealerScore = 0

# Assembles and Shuffles the Deck
function Get-ShuffledDeck {
    # Assigning all Values to the corresponding Cards
    $deck = 0..3 | Foreach {$suit = $_; 0..12 | Foreach { 
                      $num = if ($_ -eq 0) {11} elseif ($_ -ge 10) {10} else {$_ + 1}
                      @{Suit=$suits[$suit];Rank=$ranks[$_];Value=$num}}
                   }
    # Shuffling the Deck into an Array (list)
    for($i = $deck.Length - 1; $i -gt 0; --$i) {
        # Picks a random index of a card in the not shuffled deckand assigns it to new index
        $rndNdx = Get-Random -Maximum ($i+1)
        $temp = $deck[$i]
        $deck[$i] = $deck[$rndNdx]
        $deck[$rndNdx] = $temp
    }
    $deck
}
$ShuffledDeck = Get-ShuffledDeck

# This counter is for keeping track of dealing cards
# It starts at 51 because arrays start at 0 and counting 0-51 is 52 numbers
# We are doing this deck LIFO so the counter will be counting DOWN
$global:CardCounter = 51
function Deal-Card {
    # deal a card from the top of the deck 
    $ShuffledDeck[$CardCounter]
    # card no longer exists so we exclude it from the "accessible" cards
    $global:cardcounter -= 1 
}





function Show-PHand {
    
$acount = $global:PlayerHand.Count

    
"┌-----------┐  " * $acount
"|           |  " * $acount

# Display Top Face 
# # I know the code is ugly, but the ouput looks pretty
$string1 = $null 
foreach ( $o in $global:PlayerHand ) { 
 $F = $o.rank
 if ( $F -ne 10 ) { 
 $F = $F.tochararray()
 $string1 += "| $($F[0])         |  "
 }
 else {
  $string1 += "| $F        |  "
  }

}
$string1

"|           |  " * $acount

#  Display Suit
$stringS = $null 
foreach ( $o in $global:PlayerHand ) { 
 $S = $o.Suit
 if ( $S -eq 'Spades' ) { $S = '♠' }
 elseif ( $S -eq 'Hearts' ) { $S = '♥' }
 elseif ( $S -eq 'Diamonds' ) { $S = '♦' }
 elseif ( $S -eq 'Clubs' ) { $S = '♣' }

 $stringS += "|     $S     |  "

}
$stringS




"|           |  " * $acount

#  Display Bottom Face
# # I know the code is ugly, but the ouput looks pretty
$string2 = $null 
foreach ( $o in $global:PlayerHand ) { 
 $F = $o.rank
 if ( $F -ne 10 ) { 
 $F = $F.tochararray()
 $string2 += "|         $($F[0]) |  "
 }
 else {
  $string2 += "|        $F |  "
 }

}
$string2


"|           |  " * $acount
"└-----------┘  " * $acount

}

function Show-DHand {
    
$acount = $global:DealerHand.Count
    
"┌-----------┐  " * $acount
"|           |  " * $acount

# Display Top Face  
$string1 = $null 
foreach ( $o in $global:DealerHand ) { 
 $F = $o.rank
 if ( $F -ne 10 ) { 
 $F = $F.tochararray()
 $string1 += "| $($F[0])         |  "
 }
 else {
  $string1 += "| $F        |  "
  }

}
$string1

"|           |  " * $acount

#  Display Suit
$stringS = $null 
foreach ( $o in $global:DealerHand ) { 
 $S = $o.Suit
 if ( $S -eq 'Spades' ) { $S = '♠' }
 elseif ( $S -eq 'Hearts' ) { $S = '♥' }
 elseif ( $S -eq 'Diamonds' ) { $S = '♦' }
 elseif ( $S -eq 'Clubs' ) { $S = '♣' }

 $stringS += "|     $S     |  "

}
$stringS

"|           |  " * $acount

#  Display Bottom Face
$string2 = $null 
foreach ( $o in $global:DealerHand ) { 
 $F = $o.rank
 if ( $F -ne 10 ) { 
 $F = $F.tochararray()
 $string2 += "|         $($F[0]) |  "
 }
 else {
  $string2 += "|        $F |  "
  }

}
$string2

"|           |  " * $acount
"└-----------┘  " * $acount

}
function Show-DHidden {

# Display Face
$F = $global:DealerHand[0].rank
if ( $F -eq 10 ) {
    $Face1 = $F
    $Face2 = $F
}
else { 
    $F = $F.tochararray()
    $Face1 = $F[0] + ' '
    $face2 = ' ' + $F[0] 
}

# Display Suit
$S = $global:DealerHand[0].Suit
if ( $S -eq 'Spades' ) { $S = '♠' }
elseif ( $S -eq 'Hearts' ) { $S = '♥' }
elseif ( $S -eq 'Diamonds' ) { $S = '♦' }
elseif ( $S -eq 'Clubs' ) { $S = '♣' }

write-host "
+-----------+  +-----------+
|           |  |???????????|
| $Face1        |  |???????????|
|           |  |???????????|
|     $S     |  |???????????|
|           |  |???????????|
|        $Face2 |  |???????????|
|           |  |???????????|
+-----------+  +-----------+
"
}


#############################################################
# Everything Above and Below this line is Subject to Change #


function Start-Game {
    
    Clear-Host
    Write-Host "Welcome to the Game!"
    sleep 1

    [float]$bet = 0
    while ( $bet -eq 0 ) {
        #House takes bets. Bet cannot be more than reserve amount or less than .01
        $bet = Read-Host -Prompt "How much are you willing to bet? You have `$$Winnings"
         
        if ( $bet -gt $global:Winnings ) { Write-Host "Invalid amount." ; $bet = 0 }
     
        elseif ( $bet -ge 10 ) { "WOAH you're gonna break the bank with that!" ; $bet = 0 }     
        
        elseif ( $bet -gt 0 -and $bet -le $global:Winnings ){ 
            
            "Your bet is $bet" 
            
            $global:Winnings -= $bet 

            
        }

        else { Write-Host "What are you doing? Place your bet." ; $bet = 0 }
    }
   
    #Player's cards are dealt first, then dealer deals their cards.
    $global:PlayerHand = $null
    $global:PlayerHand += Deal-Card
    $global:PlayerHand += Deal-Card
    $global:PlayerScore = $global:PlayerHand[0].Value + $global:PlayerHand[1].value 
    
    $global:DealerHand = $null
    $global:DealerHand += Deal-Card
    $global:DealerHand += Deal-Card
    $global:DealerScore = $global:DealerHand[0].Value + $global:DealerHand[1].value 

    sleep 1
    # clear screen and display cards with one dealer card hidden
    Clear-Host
    sleep 1
    # One dealer card is face down, one is face up.
    Show-DHidden
    ''
    ''
    ''
    ''
    ''
    ''
    ''
    ''
    ''
    ''
    "Your bet: $bet"
    Show-PHand

    sleep .5

    # if player has blackjack, automatic win
    if ( $global:PlayerScore -eq 21 ) {

        Write-Host "You have blackjack. You Win!" 

        $global:Winnings += $bet * 2.5
        
        sleep 2
        
        break 
        
    }

 	#  If face up card is a 10 or picture card, Dealer checks for blackjack
    if ( $global:DealerHand[0].value -gt 9 ) {

        Write-Host "Dealer is checking for blackjack..." 
        sleep 2
        
        if ( $global:DealerScore -eq 21 ) {

            "Dealer has blackjack. You lose!" ; break 
        
        }
        else {

            "Dealer does not have Blackjack"
        
        }
    }

    sleep 2

    $stand = $false
    $bust = $false
    while (  -not $stand ) {
    
    Clear-Host

    Show-DHidden
    ''
    ''
    ''
    ''
    ''
    ''
    ''
    ''
    ''
    ''
    "Your bet: $bet"
    Show-PHand
    $global:PlayerScore
                
    if ( $global:PlayerScore -gt 21 ) {

    
    Write-Host "Bust. You Lose."
    $bust = $true
    sleep 2

    break

    }


    $play = Read-Host -Prompt "  1) Hit    2) Stand  "
    switch ( $play ) {
    1 { 
       # Hit me!
        $global:PlayerHand += Deal-Card
        $global:PlayerScore += $global:PlayerHand[$($global:PlayerHand.Count)-1].value 
    
      }
    2 { $stand = $true }

    default { "Invalid option" }

    }
    
    
    
    
    
    
    }

    sleep 2

    if ( -not $bust ) {

    Clear-Host

    Show-DHand
    "$global:DealerScore"
    ''
    ''
    ''
    ''
    ''
    ''
    ''
    ''
    ''
    "Your bet: $bet"
    Show-PHand
    $global:PlayerScore

    while ( $DealerScore -lt 17 ) { 
    
    $global:DealerHand += Deal-Card
    $global:DealerScore += $global:DealerHand[$($global:DealerHand.Count)-1].value 
    
    Clear-Host

    Show-DHand
    "$global:DealerScore"
    ''
    ''
    ''
    ''
    ''
    ''
    ''
    ''
    ''
    "Your bet: $bet"
    Show-PHand
    $global:PlayerScore

    if ( $global:DealerScore -gt 21 ) {

    
    Write-Host "Dealer Bust. You Win! "
    $global:Winnings += $bet * 2
    sleep 2

    break

    }


    sleep 2

    }

    if ( $global:DealerScore -gt $global:PlayerScore -and $global:DealerScore -lt 21 ) { "you lose!" }
    elseif ( $global:DealerScore -eq $global:PlayerScore ) { "You pushed" ; $global:Winnings += $bet }
    elseif ( $global:DealerScore -lt $global:PlayerScore -and $global:PlayerScore -lt 21 ) { "You Win!" ; $global:Winnings += $bet * 2 }
    else { continue }

    }

    else { break }

    sleep 5

    }

Clear-Host
while (( $inp = Read-Host -Prompt '

               WELCOME 
                              TO...

   
 _______   __         ______    ______   __    __    _____   ______    ______   __    __ 
|       \ |  \       /      \  /      \ |  \  /  \  |     \ /      \  /      \ |  \  /  \
| $$$$$$$\| $$      |  $$$$$$\|  $$$$$$\| $$ /  $$   \$$$$$|  $$$$$$\|  $$$$$$\| $$ /  $$
| $$__/ $$| $$      | $$__| $$| $$   \$$| $$/  $$      | $$| $$__| $$| $$   \$$| $$/  $$ 
| $$    $$| $$      | $$    $$| $$      | $$  $$  __   | $$| $$    $$| $$      | $$  $$  
| $$$$$$$\| $$      | $$$$$$$$| $$   __ | $$$$$\ |  \  | $$| $$$$$$$$| $$   __ | $$$$$\  
| $$__/ $$| $$_____ | $$  | $$| $$__/  \| $$ \$$\| $$__| $$| $$  | $$| $$__/  \| $$ \$$\ 
| $$    $$| $$     \| $$  | $$ \$$    $$| $$  \$$\\$$    $$| $$  | $$ \$$    $$| $$  \$$\
 \$$$$$$$  \$$$$$$$$ \$$   \$$  \$$$$$$  \$$   \$$ \$$$$$$  \$$   \$$  \$$$$$$  \$$   \$$
                                                                                         


    PICK YOUR POISON....

    1.) Play                                                                9.) Quit Game

' ) -ne 9 ) {

    Clear-Host

    switch( $inp ) {
        1 { Start-Game }
    
    
        default { "That is not a valid option!" }

    }

}
