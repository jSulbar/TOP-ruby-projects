# Chess
This is a very simple chess game made to look like gnuchess. The rules are the about same as standard chess, and to interact with the board a simplified version of algebraic notation, where nothing but the piece movements are written, is used. A couple of differences to most other chess games are:
- As described, the algebraic notation used to move is much more barebones.
- The threefold repetition rule is not present.
- No time constraints.
The game uses unicode characters and ANSI codes to change the background color of each tile, so make sure if you're playing this to use it somewhere it accepts those.

## Thoughts
This sounded easy enough. It wasn't. Though it was easy enough to implement piece movement and general game state checking, piece-specific movements like en passant or castling, which I DID NOT know how I would implement, gave me trouble.

While I learned many things from this project, one of the main takeaways is that game programming needs a lot of use of the Observer pattern, probably. My decision to make the codebase for this game adhere to my playable lib I made for the first few projects was one of the biggest problems, and it's easy to see this because there are a lot of things in methods that should be separate (fifty-move rule is updated in the process_input method), and generally the code isn't very testable which is a problem all on its own.

If I didn't stick to using Playable, I would've probably had a much smoother time implementing things like proper algebraic notation or an AI player. Unfortunately, I realized it too late to go back and program everything from scratch, so perhaps another time.

Either way, I feel like I've learned enough so that I can make a very rudimentary game on my own, so it was fun.