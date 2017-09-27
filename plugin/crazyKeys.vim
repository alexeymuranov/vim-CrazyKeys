" plugin/crazyKeys.vim
"
" Plugin Name:  Crazy Keys
" Version:      0.1.0.pre
" Last Change:  2017-09-27
" Author:       Alexey Muranov <alexeymuranov@users.noreply.github.com>
"
" Vim plug-in with crazy custom key mappings, with possibility
" to support multiple layouts (besides the common Qwerty) and
" multiple configurations (like left-handed and right-handed).
"
" This plug-in has not been intended for regular use, it is an experiment
" on mapping keys to operations based on the key's position on the
" keyboard, as opposed to mapping based on the key's character.
"
" Inspired by "Crazy Kung-Fu" movie (French title).
"
"-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
"
" Dependencies:
" * https://github.com/alexeymuranov/vim-MapToSideEffects
" * tComment
" * unimpaired
" * vim-extended-ft
" * https://github.com/benjifisher/matchit.zip
" * unite
" * vimFiler
"
"-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
"
"
" =========================================================================
" # Quick start guide                                       [documentation]
" =========================================================================
"
" Load this file and set the (default) US Qwerty right-handed mapping by
" executing
"     ~~~
"     call g:CrazyKeysSetMappingsFor('Qwerty-US-En', 'r')
"     ~~~
"
" To activate the mappings automatically on startup, use this file as a
" plugin and add to vimrc an autocommand for `VimEnter` event, for example:
"     ~~~
"     augroup MyCrazyKeys
"       autocmd!
"       autocmd VimEnter * call g:CrazyKeysSetMappingsFor('Qwerty-Ca-Fr', 'l')
"     augroup END
"     ~~~
"
" To set the US Qwerty right-handed mapping, execute
"     ~~~
"     call g:CrazyKeysSetMappingsFor('Qwerty-US-En', 'r')
"     ~~~
"
" Right-handed configuration may be easier to learn for Vim users
" because the basic cursor movement keys are on the right, while in
" left-handed configuration they are on the left (which may be easier to
" learn for Quake players).
"
" To enter Insert mode from Normal mode, press `<Space>`.  To exit, press
" `<Esc>`.
"
" A general rule for alphabetic keys is that on one side of the keyboard
" there are only motion keys, and on the opposite side there are only
" editing keys.  Keys `<t,T>` and `<y,Y>` are reserved for user-defined
" operations.
"
" There is a "standard prefix" key `<'>`, which can be used interchangeably
" with `<">`, to form key combinations of the form `<'><some_key>` and
" `<'><'><some_key>` that are usually mapped to a function related to the
" function of `<some_key>` alone.
"
" As mentionned above, keys `<t>`, `<T>`, `<y>`, `<Y>` are reserved for
" user-defined mappings.  Keys  `<\>` and `<|>` are intended to be used as
" standard prefixes for user-defined mappings (like "leader" in Vim).
"
" =========================================================================
" # Ideas                                                   [documentation]
" =========================================================================
"
" * Abandon all compatibility with the standard Vim key mapping.
"
" * Choose keys based on their position on the keyboard.
"   (In particular, there should be no difficulty adapting this plug-in to
"   any keyboard layout.)
"   Some of the keys from the number row with <Shift> may be chosen based
"   on their characters in Qwerty layout.
"   However, the `<[,{>` and `<],}>` keys are well positioned to be mapped
"   to something similar to their functions in Vim.
"   (Consider using mappings similar to Tim Pope's "unimpaired" plug-in.)
"   Probably the same holds for `<,,<>` and `<.,>>`, and for `<(>`
"   and `<)>`.
"
" * Use available keys more efficiently by adapting their behavior to the
"   current mode and situation.
"   (For example, `w` or `W` in Vim's Visual mode behave inconveniently,
"   unless the cursor is in the beginnning of a multi-word selection,
"   and out of the 4 motions `w`, `W`, `e`, `E` in Normal mode, it should
"   be enough to have just 3: `W`, `w`, `E`, where `E` should probably be
"   redefined to leave the cursor *after* the end of the word.)
"
" * Reserve two or more "modifier prefixes" which will serve as extra
"   modifiers for a key: at least one for standard functions, and at least
"   one for user-defined functions.
"   For example, `<'>` and `<Shift-'>` = `<">` can be used for standard
"   functions, and `<\>` and `<Shift-\>` = `<|>` for user-defined
"   functions.
"   Consider using the prefix `<">` synonymously with `<'>`, and `<|>`
"   synonymously with `<\>` (to simplify their "semantics" and to avoid
"   having to press or release the `<Shift>` key in the middle of a key
"   sequence).
"
" * Consider using the following semantics for the standard modifier prefix
"   (`<'>`): strip the modified command from any "intelligence."
"   For example, stop treating the whitespace intelligently, or stop
"   distinguishing whitespace from non-whitespace if possible.
"
" * Do not map sequences of more than 2 characters unless the sequence
"   can be split into an at-most-2-key-long operator mapping and
"   at-most-2-key-long motion mapping, or into a one-key prefix and
"   at-most-2-key other command.  Consider using "short" Command-line
"   commands (or menus?) instead of "long" mappings.  The advantages are:
"   - seeing well what you are typing, and
"   - not having to worry about the mapping timeout.
"
" * Think about assigning a prefix, `<p>`/`<P>`, for example, to define
"   less commonly used multi-key mappings.
"   Maybe all key pairs starting with `<p>` can be considered as "prefixes",
"   each one for a specialized set of mappings.
"   Maybe the prefix `pp` can be used for less common motions.
"   The keys following the prefix should not depend on the choice of left-
"   or right-handed layout and should be chosen based on some mnemonics.
"   Candidat operations to be accessibly through such prefix:
"   - folding/unfolding,
"   - indenting/unindenting (especially if this is accessible through
"     something like `<C-A-Left>`/`<C-A-Right>`),
"   - commenting/uncommenting.
"
" * A better idea than the previous one: use `<p>` key to start a
"   "special" command mode to enter short, tersely abbreviated commands,
"   followed by Enter key.  For example, to indent the current line or
"   selection, it is enough to map `<p>` to Vim's `:PP` and define a
"   command `PPi`; then, entering `pi<CR>` (in the default layout) will
"   indent the current line.  The `count` prefix may easily be taken into
"   account.
"
" * Mostly define functions for printable character keys and character keys
"   with `<Shift>` in normal and visual modes.
"   Leave most of key combinations with `<Ctrl>` and `<Cmd>`/`<Win>`
"   close to system defaults or define them like in Emacs.
"   Exception can be made for some categories of functions, for example:
"   recording and executing macros, scrolling, etc.
"   Think about mapping `<Alt>` with keys (remember that this will
"   not work with certain terminals, see `:h map-alt-keys`).
"   Maybe `<Alt>` can be used strictly as an alternative of the `<'>`
"   prefix?
"
" * Use `<Del>` and/or `<Backspace>` with or without modifiers to delete
"   without saving to a register.
"
" * Define and implement most motions in terms of pattern search (in
"   VimScript the implementation can use `search()` function).
"
" * Organise keys with related functions into contiguous regions on the
"   keyboard (for example: 2, or 3, or 4 keys in a row).
"
" * Do not use "insert after" (`a` in Vim).
"   The "current character insert position" is implied to always be before
"   the "current character".
"   (In my opinion, inserting after the current character is not much more
"   useful than inserting after the current word.)
"   Compensate this with appropriate movement commands.
"   For example, moving to the end of a word should move the cursor to the
"   first space, or empty position, after the end of the word.
"   Similarly, pasting should paste before the current character.
"   Pasting a line should by default paste before the current line.
"   It seems useful, however, to be able to paste after the current line
"   too.
"
" * Remember that the editor can be used in read-only mode (as a viewer),
"   so group keys for editing commands together.
"   In the read-only mode, those keys may be assigned new functions.
"
" * Always try to assign a key and `<Shift>` with that key to related, or
"   similar, or complementary functions.
"
" * Reserve one or two well placed keys (`<t,T>` and `<y,Y>`, or single
"   `<b,B>`) for user defined functions.
"   (If only `<b,B>` is provided, the user still should not complain
"   as this key is found under the user's nose).
"
" * Remap the easy to type keys `<Space>`, `<BS>`, `<CR>`, `<Tab>`
"   differently in each mode, taking into account which actions are more
"   common in which mode.  When doing so, consider mapping `<Ctrl-key>` to
"   an action similar to the "usual" action of `<key>` for these keys.
"
" * Use `<Enter>` key in a regular buffer to enter Command mode,
"   at least from Normal mode.  In other modes and window/buffer kinds it
"   should also have important roles.
"
" * Avoid mapping a proper prefix of the key sequence of another mapping.
"   This may be confusing, especially with long 'timeout'.
"   A possible exception: screen scrolling.
"
" * In Cmdline and Insert modes, try to avoid reinventing a wheel: use some
"   standard key bindings for editing, like those of *tcsh* (in vi or in
"   Emacs mode) or of Emacs.
"
" * Use a command (`:rec`?) to start recording macros, thus liberating one
"   more key for common editing functions.  Users who use macros a lot
"   shall be able to assign one of the "user keys" to this splendid
"   function.  However, using, for example, a `<Ctrl>`-key combination to
"   start recording a macro also seems like a good idea.
"
" * Think about assigning simple keys for `q"` and `@"` -- recording and
"   running a macro in the unnamed register.
"   It seems that it is possible to synchronize `@@` with `@"` (either they
"   are already the same, or the command `:let @@=@"` can be used).
"   In this case, it is better to assign a key to `@@` than to `@"`.
"   However, note the above idea about using a command to start recording a
"   macro.
"
" * Consider assigning some well-positioned keys to less common functions,
"   so that the user could remap them if desired.
"   This is in addition to the reserved user keys and user prefixes.
"   Alternatively, designate some group of keys as "redefinable", so that
"   when Vim is called from another application (like Git), those keys
"   could be safely automatically reassigned to some contextual functions.
"
" * For multi-key commands, think about putting the object before the
"   modifier before the action (kind of `wid` instead of `diw`).
"   For example, consider dividing all multi-key commands into a first part
"   that enters the visual mode and selects something, and a single key
"   that calls the action.
"   Better, consider applying operations like "delete" or "change" not to
"   the movement or the object given after the command, but to the last
"   movement (if there is no current selection), as long as it is not older
"   than, say, 3-second-old.
"   The "path" of each movement stays highlighted for 3 seconds, and any
"   operation key during this period operates on the highlighted text.
"   If the last movement is more than 3 second old, the first press of an
"   operation key highlights it again for 3 seconds, and the second press
"   of the same or other operation key, given within 3 seconds, performs
"   the corresponding operation.
"   Alternatively, operators may always act on the last movement, unless
"   <Esc> has been pressed after the movement in the normal mode, or the
"   current buffer has been changed.
"
" * Consider using the key that repeats the last "go to symbol" command to
"   repeat any motion command that requires more than one key
"   (or one key with `<Shift>`).
"
" * Think about a command that copies the unnamed register to a given
"   register (like `:let @a=@"`).
"
" * Think about the following idea: using some modifier-key combinations
"   (other than with single `<Shift>`) in insert mode may exit the insert
"   mode automatically.
"
" * With a mouse, consider defining a modifier (`<Cmd>`/`<Win>` for
"   example) such that clicking with this modifier enters immediately the
"   insert mode in the place of the click.
"
"
" =========================================================================
" # Default layout                                             [references]
" =========================================================================
"
" The target Qwerty layout:
"
"     +---------------------------+---------------------------+
"     | 1 2 3 4 5 6 7 8 9 0 - =   | ! @ # $ % ^ & * ( ) _ +   |
"     |  q w e r t y u i o p [ ]  |  Q W E R T Y U I O P { }  |
"     |   a s d f g h j k l ; ' \ |   A S D F G H J K L : " | |
"     |  ` z x c v b n m , . /    |  ~ Z X C V B N M < > ?    |
"     +---------------------------+---------------------------+
"
"
" =========================================================================
" # Abort loading if already loaded or incompatible                  [code]
" =========================================================================
"
if exists('g:loaded_crazy_keys')
  finish
endif

if v:version < 704 || !has('patch-7.4.502')
  echo "CrazyKeys: you need at least Vim 7.4.502"
  finish
elseif &compatible
  echo "CrazyKeys: you need to have 'nocompatible' set"
  finish
endif
" XXX: while in development, the following line is commented out
"let g:loaded_crazy_keys = 1

" =========================================================================
" # Support for multiple layouts and configurations                  [code]
" =========================================================================
"
" NOTE: most of this section would not be needed if the following worked as
"   expected (by me), which actually should work starting from Vim 7.4.502:
"   set langmap=йцукенгшщзфывапролдячсмитьбю;qwertyuiopasdfghjklzxcvbnm
"         \\\,.,ЙЦУКЕНГШЩЗФЫВАПРОЛДЖЯЧСМИТЬ;QWERTYUIOPASDFGHJKL:ZXCVBNM

let g:CrazyKeysMenuItemLayoutDescription = {
      \ 'Qwerty-US-En' : 'US\ English\ Qwerty',
      \ 'Qwerty-Ca-Fr' : 'Canadian\ French\ Qwerty',
      \ 'Russian' : 'Russian'
      \ }
let s:menu_item_configuration_description = {
      \ 'r' : 'right-handed',
      \ 'l' : 'left-handed'
      \ }

for s:layout_key in ['Qwerty-US-En', 'Qwerty-Ca-Fr', 'Russian']
  for s:configuration_key in ['l', 'r']
    let s:value =
          \ g:CrazyKeysMenuItemLayoutDescription[s:layout_key] . '\ ' .
          \ s:menu_item_configuration_description[s:configuration_key]
    execute 'nnoremenu &Plugin.&CK.' . s:value .
          \ ' :call g:CrazyKeysSetMappingsFor('''
          \ . s:layout_key . ''', ''' . s:configuration_key . ''')<CR>'
  endfor
endfor
nnoremenu &Plugin.&CK.Echo\ current\ layout :let g:CrazyKeysLayout<CR>

" US Qwerty (default) keys to map:
"
"   qwertyuiop
"   asdfghjkl;
"   zxcvbnm,./
"   []'\`
"   QWERTYUIOP
"   ASDFGHJKL:
"   ZXCVBNM<>?
"   {}"|~
"   !@#$%^&*()
"   -=_+
"   0

let s:u_s_qwerty_keys_to_map = [
      \ 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
      \ 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';',
      \ 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/',
      \ '[', ']', '''', '\', '`',
      \ 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P',
      \ 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':',
      \ 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '<', '>', '?',
      \ '{', '}', '"', '|', '~',
      \ '!', '@', '#', '$', '%', '^', '&', '*', '(', ')',
      \ '-', '=', '_', '+',
      \ '0'
      \ ]

let s:u_s_qwerty_lh_standard_prefix = ''''
let s:u_s_qwerty_lh_standard_prefix_with_shift = '"'
let s:u_s_qwerty_lh_user_prefix = '\'
let s:u_s_qwerty_lh_user_prefix_with_shift = '|'

let s:u_s_qwerty_2plus_key_sequences_to_map_in_modes = {
      \ 'n' : [
      \   '''h',
      \   '''x', '''c', '''X', '''C',
      \   '''l', '''k',
      \   '''i', '''I', '''o', '''O',
      \   '''j', '''J', ''';', ''':',
      \   ''',', '''.', '''<', '''>',
      \   '__', '_-', '_=',
      \   '++',
      \   '''p', '''P',
      \   '''&', '''^',
      \   '''u', '''U',
      \   '''%',
      \   '''A', '''''A', 'aa', '''aa',
      \   '''s', '''S',
      \   'dd', '''d',
      \   'ff', 'af', 'aff', 'aF',
      \   '''t', '''T',
      \   '''q', '''Q',
      \   'zz', 'zZ', '''zz', '''zZ', '''Z', '''''Z',
      \   '''''l', '''''k', '''''j',
      \   '[[', ']]', '[]', '][',
      \   '''-', '0-', '''=', '0=',
      \   '''*',
      \   '''/', '''?'
      \   ],
      \ 'v' : [
      \   '''h',
      \   '''l', '''k',
      \   '''i', '''I', '''o', '''O',
      \   '''j', '''J', ''';', ''':',
      \   ''',', '''.', '''<', '''>',
      \   '__', '_-', '_=',
      \   '++',
      \   '''p', '''P',
      \   '''&', '''^',
      \   '''u', '''U',
      \   '''a',
      \   '``s', '``S',
      \   '''d',
      \   'af', '''F',
      \   '''q', '''Q',
      \   '''Z', '''''Z',
      \   '''''l', '''''k', '''''j',
      \   '[[', ']]', '[]', '][',
      \   '00',
      \   '''-', '0-', '''=', '0=',
      \   '''*',
      \   '''/', '''?'
      \   ],
      \ 'o' : [
      \   '''l', '''k',
      \   '''i', '''I', '''o', '''O',
      \   '''j', '''J', ''';', ''':',
      \   ''',', '''.', '''<', '''>',
      \   '__', '_-', '_=',
      \   '[[', ']]', '[]', '][',
      \   '''-', '0-', '''=', '0=',
      \   '''*',
      \   '''/', '''?',
      \   '''u', '''U'
      \   ]
      \ }

let s:_u_s_qwerty_left_handed__mapping_in_modes = { 'n' : {} }

function! s:escape_bar_character_for_mapping(key_seq)
  " The character '|' has to be replaces with '<bar>' because it has a
  " special meaning in Vim commands.
  return substitute(a:key_seq, '|', '<bar>', 'g')
endfunction

for s:key in s:u_s_qwerty_keys_to_map
  let s:_u_s_qwerty_left_handed__mapping_in_modes['n'][s:key] =
        \ '<SID>key_' . s:escape_bar_character_for_mapping(s:key)
endfor

for s:mode in ['v', 'o']
  let s:_u_s_qwerty_left_handed__mapping_in_modes[s:mode] =
        \ copy(s:_u_s_qwerty_left_handed__mapping_in_modes['n'])
endfor

for s:mode in ['n', 'v', 'o']
  for s:key_seq in s:u_s_qwerty_2plus_key_sequences_to_map_in_modes[s:mode]
    let s:_u_s_qwerty_left_handed__mapping_in_modes[s:mode][s:key_seq] =
          \ '<SID>' . strlen(s:key_seq) . 'keyseq_' .
          \ s:escape_bar_character_for_mapping(s:key_seq)
  endfor
endfor

let g:CrazyKeysLayouts = { 'Qwerty-US-En' : {} }
let g:CrazyKeysConfigurations = { 'r' : {} }

" NOTE: the key position is on the right, the key function (the
"   corresponding key of the default configuration) is on the left.
let g:CrazyKeysConfigurations['l'] = {
      \ 'p' : 'q',
      \ 'i' : 'w',
      \ 'o' : 'e',
      \ 'u' : 'r',
      \ 'y' : 't',
      \ 't' : 'y',
      \ 'r' : 'u',
      \ 'w' : 'i',
      \ 'e' : 'o',
      \ 'q' : 'p',
      \
      \ 'j' : 'a',
      \ 'l' : 's',
      \ 'k' : 'd',
      \ ';' : 'f',
      \ 'h' : 'g',
      \ 'g' : 'h',
      \ 'f' : 'j',
      \ 'd' : 'k',
      \ 's' : 'l',
      \ 'a' : ';',
      \
      \ '/' : 'z',
      \ ',' : 'x',
      \ '.' : 'c',
      \ 'm' : 'v',
      \ 'n' : 'b',
      \ 'b' : 'n',
      \ 'v' : 'm',
      \ 'x' : ',',
      \ 'c' : '.',
      \ 'z' : '/',
      \
      \ '`' : '''',
      \ '''' : '`',
      \
      \ 'P' : 'Q',
      \ 'I' : 'W',
      \ 'O' : 'E',
      \ 'U' : 'R',
      \ 'Y' : 'T',
      \ 'T' : 'Y',
      \ 'R' : 'U',
      \ 'W' : 'I',
      \ 'E' : 'O',
      \ 'Q' : 'P',
      \
      \ 'J' : 'A',
      \ 'L' : 'S',
      \ 'K' : 'D',
      \ ':' : 'F',
      \ 'H' : 'G',
      \ 'G' : 'H',
      \ 'F' : 'J',
      \ 'D' : 'K',
      \ 'S' : 'L',
      \ 'A' : ':',
      \
      \ '?' : 'Z',
      \ '<' : 'X',
      \ '>' : 'C',
      \ 'M' : 'V',
      \ 'N' : 'B',
      \ 'B' : 'N',
      \ 'V' : 'M',
      \ 'X' : '<',
      \ 'C' : '>',
      \ 'Z' : '?',
      \
      \ '~' : '"',
      \ '"' : '~'
      \ }

let g:CrazyKeysLayouts['Qwerty-Ca-Fr'] = {
      \ '/' : 'é',
      \
      \ '[' : '^',
      \ ']' : 'ç',
      \ '''' : 'è',
      \ '\' : 'à',
      \ '`' : 'ù',
      \
      \ '<' : '''',
      \ '>' : '"',
      \ '?' : 'É',
      \
      \ '{' : '¨',
      \ '}' : 'Ç',
      \ '"' : 'È',
      \ '|' : 'À',
      \ '~' : 'Ù',
      \
      \ '^' : '?'
      \ }

let g:CrazyKeysLayouts['Russian'] = {
      \ 'q' : 'й',
      \ 'w' : 'ц',
      \ 'e' : 'у',
      \ 'r' : 'к',
      \ 't' : 'е',
      \ 'y' : 'н',
      \ 'u' : 'г',
      \ 'i' : 'ш',
      \ 'o' : 'щ',
      \ 'p' : 'з',
      \ '[' : 'х',
      \ ']' : 'ъ',
      \
      \ 'a' : 'ф',
      \ 's' : 'ы',
      \ 'd' : 'в',
      \ 'f' : 'а',
      \ 'g' : 'п',
      \ 'h' : 'р',
      \ 'j' : 'о',
      \ 'k' : 'л',
      \ 'l' : 'д',
      \ ';' : 'ж',
      \
      \ 'z' : 'я',
      \ 'x' : 'ч',
      \ 'c' : 'с',
      \ 'v' : 'м',
      \ 'b' : 'и',
      \ 'n' : 'т',
      \ 'm' : 'ь',
      \ ',' : 'б',
      \ '.' : 'ю',
      \ '/' : '/',
      \
      \ '''' : 'э',
      \ '\' : 'ё',
      \
      \ '`' : ']',
      \
      \ 'Q' : 'Й',
      \ 'W' : 'Ц',
      \ 'E' : 'У',
      \ 'R' : 'К',
      \ 'T' : 'Е',
      \ 'Y' : 'Н',
      \ 'U' : 'Г',
      \ 'I' : 'Ш',
      \ 'O' : 'Щ',
      \ 'P' : 'З',
      \ '{' : 'Х',
      \ '}' : 'Ъ',
      \
      \ 'A' : 'Ф',
      \ 'S' : 'Ы',
      \ 'D' : 'В',
      \ 'F' : 'А',
      \ 'G' : 'П',
      \ 'H' : 'Р',
      \ 'J' : 'О',
      \ 'K' : 'Л',
      \ 'L' : 'Д',
      \ ':' : 'Ж',
      \
      \ 'Z' : 'Я',
      \ 'X' : 'Ч',
      \ 'C' : 'С',
      \ 'V' : 'М',
      \ 'B' : 'И',
      \ 'N' : 'Т',
      \ 'M' : 'Ь',
      \ '<' : 'Б',
      \ '>' : 'Ю',
      \ '?' : '?',
      \
      \ '"' : 'Э',
      \ '|' : 'Ё',
      \
      \ '~' : '['
      \ }

" Find a translation from the default "right-handed" US Qwerty to the
" specified layout and configuration.
function! s:get_key_transltation_from_default_to(layout, configuration)
  let l:layout_keymap        = g:CrazyKeysLayouts[a:layout]
  let l:configuration_keymap = g:CrazyKeysConfigurations[a:configuration]

  let l:keymap = {}
  let l:layout_keymap = copy(l:layout_keymap)
  for [l:key, l:value] in items(l:configuration_keymap)
    if has_key(l:layout_keymap, l:value)
      let l:value = remove(l:layout_keymap, l:value)
    endif
    let l:keymap[l:key] = l:value
  endfor
  return extend(l:keymap, l:layout_keymap)
endfunction

" XXX: this function is not usable due to current behavior of 'langmap',
"   maybe it can be used in future versions of Vim
function! s:langmap_string_for(layout, configuration)
  let l:keymap =
        \ s:get_key_transltation_from_default_to(a:layout, a:configuration)
  let l:langmap_string_pieces = []
  for [l:key, l:value] in items(l:keymap)
    let l:escaped_key   = escape(l:key, ';,\')
    let l:escaped_value = escape(l:value, ';,\')
    let l:langmap_string_pieces += [ l:escaped_value . l:escaped_key ]
  endfor
  return join(l:langmap_string_pieces, ',')
endfunction

function! g:CrazyKeysClearCurrentMappings()
  if empty(g:CrazyKeysLayout)
    return
  endif

  let l:keymap =
        \ s:get_key_transltation_from_default_to(g:CrazyKeysLayout[0],
        \                                        g:CrazyKeysLayout[1])
  let g:CrazyKeysLayout = ['Error: clearing is in progress.']

  for s:mode in ['n', 'v', 'o']
    for l:key_seq in keys(s:_u_s_qwerty_left_handed__mapping_in_modes[s:mode])
      let l:translated_key_list = []
      " Process individual characters
      for l:key in split(l:key_seq, '\zs')
        let l:translated_key_list += [get(l:keymap, l:key, l:key)]
      endfor
      let l:key_seq = join(l:translated_key_list, '')
      execute s:mode . 'unmap' s:escape_bar_character_for_mapping(l:key_seq)
    endfor
  endfor

  let g:CrazyKeysLayout = []
endfunction

function! g:CrazyKeysSetMappingsFor(layout, configuration)
  if exists('g:CrazyKeysLayout')
    call g:CrazyKeysClearCurrentMappings()
  endif

  " NOTE: these two lines are for testing only, they break mappings
  "   from dependency plugins
  " mapclear
  " mapclear!

  call s:remove_some_conflicting_mappings()

  call s:set_desired_settings()

  let l:keymap =
        \ s:get_key_transltation_from_default_to(a:layout, a:configuration)

  let g:CrazyKeysLayout = ['Error: setting is in progress.']

  call s:confugure_desired_configurations(l:keymap)
  " call s:confugure_desired_configurations({})

  for s:mode in ['n', 'v', 'o']
    for [l:key_seq, l:value] in
          \ items(s:_u_s_qwerty_left_handed__mapping_in_modes[s:mode])
      let l:translated_key_list = []
      " Process individual characters
      for l:key in split(l:key_seq, '\zs')
        let l:translated_key_list += [get(l:keymap, l:key, l:key)]
        " let l:translated_key_list += [l:key]
      endfor
      let l:key_seq = join(l:translated_key_list, '')
      execute s:mode . 'noremap <script>'
            \ s:escape_bar_character_for_mapping(l:key_seq)
            \ l:value
    endfor
  endfor

  " Make Shift-"prefix" work as "prefix" for the standard prefix and the
  " user prefix
  let [l:sp, l:ssp, l:up, l:sup] =
        \ [ s:u_s_qwerty_lh_standard_prefix,
        \   s:u_s_qwerty_lh_standard_prefix_with_shift,
        \   s:u_s_qwerty_lh_user_prefix,
        \   s:u_s_qwerty_lh_user_prefix_with_shift ]
  for [l:p, l:sp] in [[l:sp, l:ssp], [l:up, l:sup]]
    let l:etp =
          \ s:escape_bar_character_for_mapping(get(l:keymap, l:p, l:p))
    let l:etsp =
          \ s:escape_bar_character_for_mapping(get(l:keymap, l:sp, l:sp))
    execute 'map' l:etsp  l:etp
    execute 'map' l:etsp . l:etsp l:etp . l:etp
  endfor

  " TODO: put autocommands here

  let g:langmap_string = s:langmap_string_for(a:layout, a:configuration)
  " let &g:langmap = g:langmap_string
  let g:CrazyKeysLayout = [a:layout, a:configuration]
endfunction

function! g:CrazyKeysChangeMappingsForLayout(layout)
  call g:CrazyKeysSetMappingsFor(a:layout, g:CrazyKeysLayout[1])
  " Echo the current layout:
  let g:CrazyKeysLayout
endfunction

function! g:CrazyKeysChangeMappingsForConfiguration(configuration)
  call g:CrazyKeysSetMappingsFor(g:CrazyKeysLayout[0], a:configuration)
  " Echo the current layout:
  let g:CrazyKeysLayout
endfunction


" =========================================================================
" # User Commands                                                    [code]
" =========================================================================
"
command! CrazyKeysDefaultLeftHandUSQwerty
      \ call g:CrazyKeysSetMappingsFor('Qwerty-US-En', 'l')
command! CrazyKeysDefaultRightHandUSQwerty
      \ call g:CrazyKeysSetMappingsFor('Qwerty-US-En', 'r')
command! CrazyKeysSetLeftHand
      \ call g:CrazyKeysChangeMappingsForConfiguration('l')
command! CrazyKeysSetRightHand
      \ call g:CrazyKeysChangeMappingsForConfiguration('r')
command! CrazyKeysChangeHand
      \ call g:CrazyKeysSetMappingsFor(g:CrazyKeysLayout[0],
      \        {'l':'r','r':'l'}[g:CrazyKeysLayout[1]])


"-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
"
"
" =========================================================================
" # Settings and configurations                                      [code]
" =========================================================================
"
function! s:set_desired_settings()
  " Allow Visual block selection past the ends of lines,
  " allow to move the cursor just beyond the end of line in Normal mode:
  set virtualedit=block,onemore

  " Allow some movement commands in some modes to wrap between the end of
  " one line and the beginning of the next:
  set whichwrap+=b,s,<,>,[,]

  " XXX: this is untested and not understood, it is just set for stability
  "   based on the existing settings
  set cpoptions=aABceFs

  " Make 'langmap' work as expected (by me):
  set langnoremap

  " TODO: set and use appropriately 'selection' option, after testing it
  " set selection = exclusive

  " TODO: consider doing something like this (but this does not seem to
  "   work)
  " unlet g:loaded_unimpaired
  " runtime plugin/extended-ft.vim plugin/unimpaired.vim
endfunction

function! s:confugure_desired_configurations(keymap)
  let g:mapleader = get(a:keymap, '\', '\')
  let g:vimfiler_as_default_explorer = 1

  " Fuzzily find and open a recently used file
  command! FFRecentlyUsed Unite
        \ -direction=botright -prompt-direction=below
        \ -auto-resize -start-insert
        \ file_mru
  " Fuzzily find and open a file in the working directory
  command! FFWorkingDirectory Unite
        \ -direction=botright -prompt-direction=below
        \ -auto-resize -auto-preview -start-insert
        \ file
  " Fuzzily find and open a file under the working directory
  command! FFUnderWorkingDdirectory Unite
        \ -direction=botright -prompt-direction=below
        \ -auto-resize -auto-preview -start-insert
        \ file_rec/async
  " TODO: convert most of these mappings into menus (with mappings)
  " source $VIMRUNTIME/menu.vim
  " set wildmenu
  " set cpo-=<
  " set wcm=<C-z>
  " noremap <F4> :emenu <C-z>
  noremenu <silent> File.&Jump\ To.&Recent\.\.\.
        \ :<C-u>Unite
        \ -direction=botright -prompt-direction=below
        \ -auto-resize -start-insert
        \ file_mru<CR>
  noremenu <silent> File.&Jump\ To.In\ &Working\ Directory\.\.\.
        \ :<C-u>Unite
        \ -direction=botright -prompt-direction=below
        \ -auto-resize -auto-preview -start-insert
        \ file<CR>
  noremenu <silent> File.&Jump\ To.&Under\ Working\ Directory\.\.\.
        \ :<C-u>Unite
        \ -direction=botright -prompt-direction=below
        \ -auto-resize -auto-preview -start-insert
        \ file_rec/async<CR>
  noremenu <silent> File.&Explore\.\.\.
        \ :<C-u>VimFilerCurrentDir
        \ -explorer -split -horizontal -direction=botright<CR>
  nnoremap <silent> <leader>fr :<C-u>Unite
        \ -direction=botright -prompt-direction=below
        \ -auto-resize -start-insert
        \ file_mru<CR>
  nnoremap <silent> <leader>fw :<C-u>Unite
        \ -direction=botright -prompt-direction=below
        \ -auto-resize -auto-preview -start-insert
        \ file<CR>
  " NOTE: 'file_rec/async' requires a properly built Vimproc
  nnoremap <silent> <leader>fu :<C-u>Unite
        \ -direction=botright -prompt-direction=below
        \ -auto-resize -auto-preview -start-insert
        \ file_rec/async<CR>
  nnoremap <silent> <leader>fe :<C-u>VimFilerCurrentDir
        \ -explorer -split -vertical -direction=botright<CR>
  nmap <silent> <leader>F <leader>fr
  nmap <silent> <C-r> <leader>fr
  nnoremap <silent> <leader>b :<C-u>Unite
        \ -direction=botright -prompt-direction=below
        \ -auto-resize -auto-preview -no-start-insert
        \ buffer<CR>
  nmap <silent> <leader>B <leader>b
  nnoremap <silent> <leader>y :<C-u>Unite
        \ -direction=botright -prompt-direction=below
        \ -auto-resize -no-start-insert
        \ history/yank<CR>
  nnoremap <silent> <leader>u :<C-u>Unite
        \ -direction=botright -prompt-direction=below
        \ -auto-resize -no-start-insert
        \ outline<CR>
  nnoremap <silent> <leader>tb :<C-u>TagbarToggle<CR>
  " FIXME: make this work (or at least find out what it is supposed to do)
  " nnoremap <silent> <leader>tl :<C-u>Unite
  "       \ -direction=botright -prompt-direction=below
  "       \ -no-start-insert tag/include<CR>
  nmap <silent> <leader>T <leader>tb
  " Open a scratch buffer
  nnoremap <silent> <leader>s :new<CR>:setlocal buftype=nofile<CR>
        \:setlocal bufhidden=hide<CR>:setlocal noswapfile<CR>

  " Easy tab navigation
  nnoremap <silent> <C-S-Tab> :tabprevious<CR>
  nnoremap <silent> <C-Tab> :tabnext<CR>
  inoremap <silent> <C-S-Tab> <ESC>:tabprevious<CR>i
  inoremap <silent> <C-Tab> <ESC>:tabnext<CR>i
  " nnoremap <silent> <D-t> :tabnew<CR>
  " nnoremap <silent> <C-t> :tabnew<CR>
  " inoremap <silent> <C-t> <ESC>:tabnew<CR>i
  " noremap <silent> <C-w> :tabclose<CR>

  " Easy buffer navigation
  nnoremap <silent> <F5> :buffers<CR>:buffer<Space>
  nnoremap <silent> <C-n> :bnext<CR>
  nnoremap <silent> <C-p> :bprevious<CR>

  " Easy window split navigation
  nnoremap <silent> <A-Up> :wincmd k<CR>
  nnoremap <silent> <A-Down> :wincmd j<CR>
  nnoremap <silent> <A-Left> :wincmd h<CR>
  nnoremap <silent> <A-Right> :wincmd l<CR>
endfunction

"
" #.# Workarounds and temporary fixes
" -------------------------------------------------------------------------
"
function! s:remove_some_conflicting_mappings()
  for l:ks in [
        \ 'a%',
        \ 'coc',
        \ 'cob',
        \ 'cod',
        \ 'coh',
        \ 'coi',
        \ 'col',
        \ 'con',
        \ 'cor',
        \ 'cos',
        \ 'cou',
        \ 'cov',
        \ 'cow',
        \ 'cox',
        \ 'cs',
        \ 'ds',
        \ 'g%',
        \ 'gc',
        \ 'gc1',
        \ 'gc2',
        \ 'gc3',
        \ 'gc4',
        \ 'gc5',
        \ 'gc6',
        \ 'gc7',
        \ 'gc8',
        \ 'gc9',
        \ 'gc1c',
        \ 'gc2c',
        \ 'gc3c',
        \ 'gc4c',
        \ 'gc5c',
        \ 'gc6c',
        \ 'gc7c',
        \ 'gc8c',
        \ 'gc9c',
        \ 'gcc',
        \ 'gcb',
        \ 'gx',
        \ 'gw',
        \ 'gC',
        \ 'gCc',
        \ 'gCb',
        \ 'gS',
        \ 'g>',
        \ 'g>b',
        \ 'g>c',
        \ 'g<',
        \ 'g<b',
        \ 'g<c',
        \ 'ic',
        \ 'yo',
        \ 'yO',
        \ 'ys',
        \ 'yS',
        \ 'yss',
        \ 'ySs',
        \ 'ySS',
        \ '=p',
        \ '=P'
        \ ]
    execute 'silent! unmap' l:ks
  endfor
endfunction

"
" =========================================================================
" # Actions                                                          [code]
" =========================================================================
"
" In this section various actions, in particular motions, are realised as
" function side effects.  They shall be used with MapToSideEffects plugin.
"
"
" #.# Motions
" -------------------------------------------------------------------------
"
" TODO:  Try to find and implement a reasonable and consistent behavior of
"   word-based motions in different visual modes.
"
" To Start Of Word Forward
function! s:MotionNO_ToStartOfWordForward(count1)
  let l:count1 = a:count1
  while l:count1 > 0
    call search('\<', 'W')
    let l:count1 -= 1
  endwhile
endfunction

function! s:MotionV_ToStartOfWordForward(count1)
  " TODO: test and improve if needed
  let cur_pos = getcurpos()
  let v_start = getpos('v')
  let at_end_of_v = cur_pos[1] > v_start[1] ||
        \ (cur_pos[1] == v_start[1] && cur_pos[2] >= v_start[2])
  if at_end_of_v
    normal! l
  endif
  let l:count1 = a:count1
  while l:count1 > 0
    call search('\<', 'W')
    let l:count1 -= 1
  endwhile
  let cur_pos = getcurpos()
  let v_start = getpos('v')
  let at_end_of_v = cur_pos[1] > v_start[1] ||
        \ (cur_pos[1] == v_start[1] && cur_pos[2] > v_start[2])
  if at_end_of_v
    normal! h
  endif
endfunction

" To Start Of Word Backward
function! s:MotionNO_ToStartOfWordBackward(count1)
  let l:count1 = a:count1
  while l:count1 > 0
    call search('\<', 'Wb')
    let l:count1 -= 1
  endwhile
endfunction

function! s:MotionV_ToStartOfWordBackward(count1)
  " TODO: test and improve if needed
  let l:count1 = a:count1
  while l:count1 > 0
    call search('\<', 'Wb')
    let l:count1 -= 1
  endwhile
  let cur_pos = getcurpos()
  let v_start = getpos('v')
  let at_end_of_v = cur_pos[1] > v_start[1] ||
        \ (cur_pos[1] == v_start[1] && cur_pos[2] > v_start[2])
  if at_end_of_v
    normal! h
  endif
endfunction

" To End Of Word Forward
function! s:MotionNO_ToEndOfWordForward(count1)
  let l:count1 = a:count1
  while l:count1 > 0
    " " XXX: this pattern does not work at all when the word contains non
    " "   ASCII letter
    " call search('\(\k\@<=\k\@!\)\|\(\w\@<=\w\@!\)\|\(\S\@<=\S\@!\)', 'W')
    call search('\>', 'W')
    let l:count1 -= 1
  endwhile
endfunction

function! s:MotionV_ToEndOfWordForward(count1)
  " TODO: test and improve if needed
  let cur_pos = getcurpos()
  let v_start = getpos('v')
  let at_end_of_v = cur_pos[1] > v_start[1] ||
        \ (cur_pos[1] == v_start[1] && cur_pos[2] >= v_start[2])
  if at_end_of_v
    normal! l
  endif
  let l:count1 = a:count1
  while l:count1 > 0
    call search('\>', 'W')
    let l:count1 -= 1
  endwhile
  let cur_pos = getcurpos()
  let v_start = getpos('v')
  let at_end_of_v = cur_pos[1] > v_start[1] ||
        \ (cur_pos[1] == v_start[1] && cur_pos[2] > v_start[2])
  if at_end_of_v
    normal! h
  endif
endfunction

" To End Of Word Backward
function! s:MotionNO_ToEndOfWordBackward(count1)
  let l:count1 = a:count1
  while l:count1 > 0
    " " XXX: this pattern does not work at all when the word contains non
    " "   ASCII letter
    " call search('\(\k\@<=\k\@!\)\|\(\w\@<=\w\@!\)\|\(\S\@<=\S\@!\)', 'Wb')
    call search('\>', 'Wb')
    let l:count1 -= 1
  endwhile
endfunction

function! s:MotionV_ToEndOfWordBackward(count1)
  " TODO: test and improve if needed
  let l:count1 = a:count1
  while l:count1 > 0
    call search('\>', 'Wb')
    let l:count1 -= 1
  endwhile
  let cur_pos = getcurpos()
  let v_start = getpos('v')
  let at_end_of_v = cur_pos[1] > v_start[1] ||
        \ (cur_pos[1] == v_start[1] && cur_pos[2] > v_start[2])
  if at_end_of_v
    normal! h
  endif
endfunction

" To Start Of Spaced Word Forward
function! s:MotionNO_ToStartOfSpacedWordForward(count1)
  let l:count1 = a:count1
  while l:count1 > 0
    call search('\S\@=\S\@<!', 'W')
    let l:count1 -= 1
  endwhile
endfunction

function! s:MotionV_ToStartOfSpacedWordForward(count1)
  " TODO: test and improve if needed
  let cur_pos = getcurpos()
  let v_start = getpos('v')
  let at_end_of_v = cur_pos[1] > v_start[1] ||
        \ (cur_pos[1] == v_start[1] && cur_pos[2] >= v_start[2])
  if at_end_of_v
    normal! l
  endif
  let l:count1 = a:count1
  while l:count1 > 0
    call search('\S\@=\S\@<!', 'W')
    let l:count1 -= 1
  endwhile
  let cur_pos = getcurpos()
  let v_start = getpos('v')
  let at_end_of_v = cur_pos[1] > v_start[1] ||
        \ (cur_pos[1] == v_start[1] && cur_pos[2] > v_start[2])
  if at_end_of_v
    normal! h
  endif
endfunction

" To Start Of Spaced Word Backward
function! s:MotionNO_ToStartOfSpacedWordBackward(count1)
  let l:count1 = a:count1
  while l:count1 > 0
    call search('\S\@=\S\@<!', 'Wb')
    let l:count1 -= 1
  endwhile
endfunction

function! s:MotionV_ToStartOfSpacedWordBackward(count1)
  " TODO: test and improve if needed
  let l:count1 = a:count1
  while l:count1 > 0
    call search('\S\@=\S\@<!', 'Wb')
    let l:count1 -= 1
  endwhile
  let cur_pos = getcurpos()
  let v_start = getpos('v')
  let at_end_of_v = cur_pos[1] > v_start[1] ||
        \ (cur_pos[1] == v_start[1] && cur_pos[2] > v_start[2])
  if at_end_of_v
    normal! h
  endif
endfunction

" To End Of Spaced Word Forward
function! s:MotionNO_ToEndOfSpacedWordForward(count1)
  let l:count1 = a:count1
  while l:count1 > 0
    call search('\S\@<=\S\@!', 'W')
    let l:count1 -= 1
  endwhile
endfunction

function! s:MotionV_ToEndOfSpacedWordForward(count1)
  " TODO: test and improve if needed
  let cur_pos = getcurpos()
  let v_start = getpos('v')
  let at_end_of_v = cur_pos[1] > v_start[1] ||
        \ (cur_pos[1] == v_start[1] && cur_pos[2] >= v_start[2])
  if at_end_of_v
    normal! l
  endif
  let l:count1 = a:count1
  while l:count1 > 0
    call search('\S\@<=\S\@!', 'W')
    let l:count1 -= 1
  endwhile
  let cur_pos = getcurpos()
  let v_start = getpos('v')
  let at_end_of_v = cur_pos[1] > v_start[1] ||
        \ (cur_pos[1] == v_start[1] && cur_pos[2] > v_start[2])
  if at_end_of_v
    normal! h
  endif
endfunction

" To End Of Spaced Word Backward
function! s:MotionNO_ToEndOfSpacedWordBackward(count1)
  let l:count1 = a:count1
  while l:count1 > 0
    call search('\S\@<=\S\@!', 'Wb')
    let l:count1 -= 1
  endwhile
endfunction

function! s:MotionV_ToEndOfSpacedWordBackward(count1)
  " TODO: test and improve if needed
  let l:count1 = a:count1
  while l:count1 > 0
    call search('\S\@<=\S\@!', 'Wb')
    let l:count1 -= 1
  endwhile
  let cur_pos = getcurpos()
  let v_start = getpos('v')
  let at_end_of_v = cur_pos[1] > v_start[1] ||
        \ (cur_pos[1] == v_start[1] && cur_pos[2] > v_start[2])
  if at_end_of_v
    normal! h
  endif
endfunction

" To First Nonblank Of This Or Next Line
function! s:Motion_ToFirstNonblankOfThisOrNextLine(count)
  if a:count
    execute 'normal!' a:count . '+'
  else
    let [@_, l:l_num, l:c_num, @_] = getpos('.')
    if l:c_num == match(getline(l:l_num), '\S') + 1
      normal! +
    else
      normal! ^
    endif
  endif
endfunction

" To First Column Of This Or Next Line
function! s:Motion_ToFirstColumnOfThisOrNextLine(count)
  if a:count
    execute 'normal!' a:count . '+0'
  else
    if col('.') == 1
      normal! +0
    else
      normal! 0
    endif
  endif
endfunction

" To End Of This Or Next Line
function! s:MotionNO_ToEndOfThisOrNextLine(count)
  if a:count
    execute 'normal!' a:count . '$l'
  else
    let [@_, l:l_num, l:c_num, @_] = getpos('.')
    if l:c_num == len(getline(l:l_num)) + 1
      normal! +$l
    else
      normal! $l
    endif
  endif
endfunction

" To End Of This Or Next Line in Visual
function! s:MotionV_ToEndOfThisOrNextLine(count)
  let [@_, l:l_num, l:c_num, @_] = getpos('.')
  let [@_, l:l_num_oppos, l:c_num_oppos, @_] = getpos('v')
  if a:count
    let l:l_num += a:count - 1
    let l:c_num_last_nonblank = len(getline(l:l_num))
    if (l:l_num_oppos < l:l_num) ||
          \ (l:l_num_oppos == l:l_num &&
          \  l:c_num_oppos <= l:c_num_last_nonblank)
      execute 'normal!' a:count . '$h'
    else
      execute 'normal!' a:count . '$'
    endif
  else
    let l:c_num_last_nonblank = len(getline(l:l_num))
    if (l:l_num_oppos < l:l_num) ||
          \ (l:l_num_oppos == l:l_num &&
          \  l:c_num_oppos <= l:c_num_last_nonblank)
      if l:c_num == l:c_num_last_nonblank
        normal! 2$h
      else
        normal! $h
      endif
    else
      if l:c_num == l:c_num_last_nonblank + 1
        let l:l_num += 1
        let l:c_num_last_nonblank = len(getline(l:l_num))
        if (l:l_num_oppos < l:l_num) ||
              \ (l:l_num_oppos == l:l_num &&
              \  l:c_num_oppos <= l:c_num_last_nonblank)
          normal! 2$h
        else
          normal! 2$
        endif
      else
        normal! $
      endif
    endif
  endif
endfunction

" To Column Number in Visual
function! s:MotionV_ToColumnNumber(count)
  " TODO: implement
endfunction

"
" #.# Editing
" -------------------------------------------------------------------------
"
" Delete Lines Above without copying to a register
"
" NOTE:  For consistency, it is better only to use this action in pair
"   with the analogous action that saves the deleted piece to a register.
"   Defining actions that work with registers may require developing and
"   upgrading MapToSideEffects plugin first.
function! s:ActionN_DeleteLinesAbove(count1)
  execute '-' . a:count1 . ',-1d _'
endfunction

" Cut Lines Above and save to a register
"
" XXX:  This looks like an extremely bad style to pass `v:count1` as an
"   argument while reading `v:register` directly.  Maybe having an action
"   without arguments that reads all needed Vim variables directly would
"   be a simple solution.  This kind of action shall be viewed by
"   MapToSideEffects plugin as "idempotent," but probably a synonym or
"   "alias" for "idempotent" should be created in MapToSideEffects to match
"   the different "meaning" of such actions.
function! s:ActionN_CutLinesAbove(count1)
  execute '-' . a:count1 . ',-1d ' . v:register
endfunction

"
" #.# Changing modes
" -------------------------------------------------------------------------
"
" Start Line-wise Visual Mode
function! s:ActionN_StartLineWiseVMode(count1)
  let [@_, l:line, l:column, @_] = getpos('.')
  normal! V
  call cursor(l:line + a:count1 - 1, l:column)
  normal! o
endfunction

" Switch Visual Modes between Character-wise and Block
function! s:ActionV_SwitchVisualModesCB()
  if mode() ==# "\<C-v>"
    normal! v
  else
    execute "normal! \<C-v>"
  endif
endfunction

" Switch Visual Modes between Character-wise and Line-wise
function! s:ActionV_SwitchVisualModesCL()
  if mode() ==# 'V'
    normal! v
  else
    normal! V
  endif
endfunction

"
" #.#.# Set up actions with MapToSideEffects
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"

call mapToSideEffects#Reset()

call mapToSideEffects#SetUpWithCount1(
      \ function('s:MotionNO_ToStartOfWordForward'),
      \ {'name' : 'CrazyKeys-NO_ToStartOfWordForward', 'modes' : 'no'} )

call mapToSideEffects#SetUpWithCount1(
      \ function('s:MotionV_ToStartOfWordForward'),
      \ {'name' : 'CrazyKeys-V_ToStartOfWordForward', 'modes' : 'v'} )

call mapToSideEffects#SetUpWithCount1(
      \ function('s:MotionNO_ToStartOfWordBackward'),
      \ {'name' : 'CrazyKeys-NO_ToStartOfWordBackward', 'modes' : 'no'} )

call mapToSideEffects#SetUpWithCount1(
      \ function('s:MotionV_ToStartOfWordBackward'),
      \ {'name' : 'CrazyKeys-V_ToStartOfWordBackward', 'modes' : 'v'} )

call mapToSideEffects#SetUpWithCount1(
      \ function('s:MotionNO_ToEndOfWordForward'),
      \ {'name' : 'CrazyKeys-NO_ToEndOfWordForward', 'modes' : 'no'} )

call mapToSideEffects#SetUpWithCount1(
      \ function('s:MotionV_ToEndOfWordForward'),
      \ {'name' : 'CrazyKeys-V_ToEndOfWordForward', 'modes' : 'v'} )

call mapToSideEffects#SetUpWithCount1(
      \ function('s:MotionNO_ToEndOfWordBackward'),
      \ {'name' : 'CrazyKeys-NO_ToEndOfWordBackward', 'modes' : 'no'} )

call mapToSideEffects#SetUpWithCount1(
      \ function('s:MotionV_ToEndOfWordBackward'),
      \ {'name' : 'CrazyKeys-V_ToEndOfWordBackward', 'modes' : 'v'} )

call mapToSideEffects#SetUpWithCount1(
      \ function('s:MotionNO_ToStartOfSpacedWordForward'),
      \ {'name' : 'CrazyKeys-NO_ToStartOfSpacedWordForward', 'modes' : 'no'} )

call mapToSideEffects#SetUpWithCount1(
      \ function('s:MotionV_ToStartOfSpacedWordForward'),
      \ {'name' : 'CrazyKeys-V_ToStartOfSpacedWordForward', 'modes' : 'v'} )

call mapToSideEffects#SetUpWithCount1(
      \ function('s:MotionNO_ToStartOfSpacedWordBackward'),
      \ {'name' : 'CrazyKeys-NO_ToStartOfSpacedWordBackward', 'modes' : 'no'} )

call mapToSideEffects#SetUpWithCount1(
      \ function('s:MotionV_ToStartOfSpacedWordBackward'),
      \ {'name' : 'CrazyKeys-V_ToStartOfSpacedWordBackward', 'modes' : 'v'} )

call mapToSideEffects#SetUpWithCount1(
      \ function('s:MotionNO_ToEndOfSpacedWordForward'),
      \ {'name' : 'CrazyKeys-NO_ToEndOfSpacedWordForward', 'modes' : 'no'} )

call mapToSideEffects#SetUpWithCount1(
      \ function('s:MotionV_ToEndOfSpacedWordForward'),
      \ {'name' : 'CrazyKeys-V_ToEndOfSpacedWordForward', 'modes' : 'v'} )

call mapToSideEffects#SetUpWithCount1(
      \ function('s:MotionNO_ToEndOfSpacedWordBackward'),
      \ {'name' : 'CrazyKeys-NO_ToEndOfSpacedWordBackward', 'modes' : 'no'} )

call mapToSideEffects#SetUpWithCount1(
      \ function('s:MotionV_ToEndOfSpacedWordBackward'),
      \ {'name' : 'CrazyKeys-V_ToEndOfSpacedWordBackward', 'modes' : 'v'} )

call mapToSideEffects#SetUpWithCount(
      \ function('s:Motion_ToFirstNonblankOfThisOrNextLine'),
      \ {'name' : 'CrazyKeys-ToFirstNonblankThisOrNext'} )

call mapToSideEffects#SetUpWithCount(
      \ function('s:Motion_ToFirstColumnOfThisOrNextLine'),
      \ {'name' : 'CrazyKeys-ToFirstColumnThisOrNext'} )

call mapToSideEffects#SetUpWithCount(
      \ function('s:MotionNO_ToEndOfThisOrNextLine'),
      \ {'name'  : 'CrazyKeys-NO_ToEndOfThisOrNextLine', 'modes' : 'no'} )

call mapToSideEffects#SetUpWithCount(
      \ function('s:MotionV_ToEndOfThisOrNextLine'),
      \ {'name'  : 'CrazyKeys-V_ToEndOfThisOrNextLine', 'modes' : 'v'} )

call mapToSideEffects#SetUpWithCount1(
      \ function('s:ActionN_DeleteLinesAbove'),
      \ {'name'  : 'CrazyKeys-N_DeleteLinesAbove', 'modes' : 'n'} )

call mapToSideEffects#SetUpWithCount1(
      \ function('s:ActionN_CutLinesAbove'),
      \ {'name'  : 'CrazyKeys-N_CutLinesAbove', 'modes' : 'n'} )

call mapToSideEffects#SetUpWithCount1(
      \ function('s:ActionN_StartLineWiseVMode'),
      \ {'name'  : 'CrazyKeys-N_StartLineWiseVMode', 'modes' : 'n'} )

call mapToSideEffects#SetUpIdempotent(
      \ function('s:ActionV_SwitchVisualModesCL'),
      \ {'name'  : 'CrazyKeys-V_SwitchVisualModesCL', 'modes' : 'v'} )

call mapToSideEffects#SetUpIdempotent(
      \ function('s:ActionV_SwitchVisualModesCB'),
      \ {'name'  : 'CrazyKeys-V_SwitchVisualModesCB', 'modes' : 'v'} )

"
" =========================================================================
" # Short commands to complement mappings                            [code]
" =========================================================================
"
" The idea is to use `<p>` key to start a "special" Command-line mode to
" enter short commands, followed by Enter key.  For example, to make
" `pi<CR>` key sequence in the default layout to indent the current line or
" selection, it can be enough to map `<p>` to Vim's `:PP` and define a
" command `PPi` that indents the current line or selection.
"
" FIXME: this moves the cursor to the last line of the range and turns off
"   visual selection
command! -range PPi <line1>,<line2>>
command! -range PPI <line1>,<line2><
command! -range PPc <line1>,<line2>TComment

"
" =========================================================================
" # Actual mappings                                                  [code]
" =========================================================================
"
" NOTE:  Since Vim is so weird and VimScript is such a mess, let us try to
"   follow some pragmatic rules to define custom mappings in an organised
"   manner.  Thus, different ways to define custom mappings shell be tryed
"   in the following order.
"
"   1.
"         ~~~
"         [nvo]noremap <key_sequence> <target_key_sequence>
"         ~~~
"
"   2.
"         ~~~
"         [nv]noremap <key_sequence> @="<target_key_sequence>"<CR>
"         ~~~
"     This does not work with `onoremap`.
"
"   3. When the `count` prefix needs to be discarded:
"         ~~~
"         nnoremap <key_sequence> :<C-u>norm! <target_key_sequence><CR>
"         onoremap <key_sequence> :norm! <target_key_sequence><CR>
"         ~~~
"     This does not work well with `vnoremap`: the visual selection is
"     cleared before running any Ex mode command, so it would probably need
"     to be restored using the `gv` command, but this would still have the
"     undesirable effect of forgetting the previous selection (accessible
"     otherwise with `gv`).
"
"   4.
"         ~~~
"         nnoremap <key_sequence> :<C-u>exe "norm! <target_key_sequence>"<CR>
"         onoremap <key_sequence> :exe "norm! <target_key_sequence>"<CR>
"         ~~~
"     The `<target_key_sequence>` can contain special symbols, like `<BS>`
"     (escaped as `"\<lt>BS>"`), and variable interpolations, like
"     `.v:count.`.
"
"   5.
"         ~~~
"         [nvo]noremap <expr> <key_sequence> <my_function>()
"         ~~~
"     The function `<my_function>` should use `return` and avoid `normal!`
"     `execute` and `feedkeys`.  The name `<my_function>` should contain
"     something like `map_expr` or `MapExpr`.
"
"     A possible workaround for some ostensible restrictions of this method
"     is to use a "callback" in the returned key sequence like this:
"         ~~~
"         return `"<main_keys>@='\<lt>SID><callback>()'\<lt>CR>"`,
"         ~~~
"     where `<callback>` is an adhoc function or funcref.
"
"   6.
"         ~~~
"         [nv]noremap <key_sequence> @=<SID><my_function>()<CR>
"         ~~~
"     The function `<my_function>` should use `return` and avoid
"     `execute` and `feedkeys`.  The name `<my_function>` should
"     contain something like `map_ereg` or `MapEReg`.
"
"   7.
"         ~~~
"         nnoremap <key_sequence> :<C-u>call <SID><my_function>()<CR>
"         onoremap <key_sequence> :call <SID><my_function>()<CR>
"         ~~~
"     The function `<my_function>` should either not use `return` or
"     use it without argument (thus returning 0).  The name
"     `<my_function>` should contain something like `map_call` or
"     `MapCall`.
"
"   8.
"         ~~~
"         [nv]noremap <expr> <key_sequence>
"                 \ "@_@=\<SID><my_function>(".v:count1.")\<CR>"
"         ~~~
"     The function `<my_function>` should preferably return the empty string
"     `''`, while producing the desired side effects.  The name
"     `<my_function>` should contain something like `map_exprereg` or
"     `MapExprEReg`.
"
"   In all the above cases, `<key_sequence>` is a key sequence starting
"   with `<SID>` or `<Plug>`.
"
" TODO: make actions repeatable with the ususal "repeat" key and motions
"   repeatable with the "repeat-go-to-character" key
"
"
" #.# Normal and visual mode mappings
" -------------------------------------------------------------------------
"
" #.#.# Standard prefixes
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  `'`, `"` - standard prefix
noremap <SID>key_' <Nop>
noremap <SID>key_" <Nop>

"
" #.#.# User prefixes
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  `\`, `|` - user prefix (leader)
"  XXX: see also `s:confugure_desired_configurations(keymap)` function.
noremap <SID>key_\     <Nop>
noremap <SID>key_<bar> <Nop>

"
" #.#.# Modes
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  <CR>   - command mode (`:`), except when in command window (see
"           `:h cmdline-window`), see also the section about Cmdline mode
"           mappings
"  <C-CR>, <C-x> - command mode (`:`)
"           (duplicate mappings for the case when a different function is
"           assigned to <CR>)
"  '<CR>, <A-CR>, <S-CR> - open the command-line window (`q:`)
"  h  - visual mode (`v`)
"       in visual mode: visual block-wise mode
"  H  - without count, start line-wise visual mode (`V`); with count, start
"       line-wise visual mode and select [count] lines
"  'h - Normal mode: last selection (`gv`)
"  'h - Visual mode: last selection (`gv`)
"  <Space>   - from Normal mode to Insert mode (`i`),
"              unless in 'readonly' mode;
"              in Normal 'readonly' mode: scroll as <PageDown>
"  <S-Space> - from Normal mode to Insert mode in the same position as where
"              Insert mode was stopped last time in the current buffer (`gi`),
"              unless in 'readonly' mode (not implemented);
"              in Normal 'readonly' mode: scroll as <PageUp>
"              in other modes: return to Normal mode
"  <C-Space> - return to the normal mode, except when in Normal mode;
"              in Normal mode go one page forward (`<C-f>` in Vim), like
"              plain `<Space>` in a read-only buffer
"  <C-S-Space> - in Normal mode go one page backward (`<C-b>` in Vim),
"              like `<S-Space>` in a read-only buffer
"  <Esc>     - in Normal mode: cancel the count, if any (`@_` in Vim),
"              otherwise clear last search higlighting and everything else;
"              in Visual mode: cancel the count, if any (`@_` in Vim),
"              otherwise exit to Normal mode and leave the cursor on the
"              start or to the right of the end of the selection;
"              in Operator-pending mode: `<Esc>` in Vim;
"              in Insert mode: exit to Normal mode (without moving the
"              cursor one character to the left, unlike Vim
"              (`<Esc>\(backquote)^` in Vim);
"              in command window (`:h cmdwin`) behave like `<C-c>`,
"              see  the section about Cmdline mode mappings
"  g  - replace a single character with another character, or a visual
"       selection with one character (`r`)
"  G  - replace mode (`R`)
"  x  - Normal: insert before the first non-blank character of the line (`I`)
"  c  - Normal: insert at the last character of the line (`A`)
"  x  - Visual: (`I`)
"  c  - Visual: (`A`)
"  'x - Normal: insert before the first character of the line (`0i`)
"  'c - Normal: insert at the last non-blank character of the line (`g_a`)
"  X  - smart open a line above -- with indentation, etc. (`O`)
"  C  - smart open a line below -- with indentation, etc. (`o`)
"  'X - open an empty line above and go to the beginning (`O<C-u>`)
"  'C - open an empty line below and go to the beginning (`o<C-u>`)
"
" NOTE: it was stated on StackOverflow that "remapping <CR> in Normal mode
"   interferes with selection of history items in the command-line window
"   and with jumping to error under cursor in quickfix/location list
"   windows".
nnoremap <CR> :
vnoremap <CR> :
nnoremap <C-CR> :
vnoremap <C-CR> :
nnoremap <C-x> :
vnoremap <C-x> :
nnoremap <SID>key_'<CR> q:
vnoremap <SID>key_'<CR> q:
nnoremap <script> <A-CR> <SID>key_'<CR>
vnoremap <script> <A-CR> <SID>key_'<CR>
nnoremap <script> <S-CR> <SID>key_'<CR>
vnoremap <script> <S-CR> <SID>key_'<CR>

nnoremap <SID>key_h v

nmap <SID>key_H <Plug>(CrazyKeys-N_StartLineWiseVMode)

vmap <SID>key_h <Plug>(CrazyKeys-V_SwitchVisualModesCB)
vmap <SID>key_H <Plug>(CrazyKeys-V_SwitchVisualModesCL)

nnoremap <SID>2keyseq_'h gv
vnoremap <SID>2keyseq_'h gv

noremap  <script> <C-l> <SID>key_<Esc>
inoremap <script> <C-l> <SID>key_<Esc>
noremap  <script> <C-Space> <SID>key_<Esc>
noremap! <script> <C-Space> <SID>key_<Esc>
nnoremap          <C-Space>   <C-f>
nnoremap          <C-S-Space> <C-b>
" XXX: <S-Space> does not work in terminals
noremap  <script> <S-Space> <SID>key_<Esc>
noremap! <script> <S-Space> <SID>key_<Esc>

" function! s:NMapExpr_SpaceKey()
"   if &readonly
"     return "\<C-f>"
"   else
"     return 'i'
"   endif
" endfunction
"
" function! s:NMapExpr_ShiftSpaceKey()
"   if &readonly
"     return "\<C-b>"
"   else
"     return 'gi'
"   endif
" endfunction
"
" nnoremap <expr> <Space>   <SID>NMapExpr_SpaceKey()
" nnoremap <expr> <S-Space> <SID>NMapExpr_ShiftSpaceKey()

nnoremap <expr> <Space>   (&readonly?"\<C-f>":'i')
nnoremap <expr> <S-Space> (&readonly?"\<C-b>":'gi')

function! s:NMapExpr_EscKey()
  if v:count
    return '@_'
  else
    return "\<Esc>:noh\<CR>"
  endif
endfunction
nnoremap <expr> <SID>key_<Esc> <SID>NMapExpr_EscKey()
function! s:VMapExpr_EscKey()
  if v:count
    return '@_'
  endif
  let [@_, l:l_num, l:c_num, @_] = getpos('.')
  let [@_, l:l_num_oppos, l:c_num_oppos, @_] = getpos('v')
  if (l:l_num_oppos < l:l_num) ||
        \ (l:l_num_oppos == l:l_num &&
        \  l:c_num_oppos <= l:c_num)
    let l:at_end = 1
  else
    let l:at_end = 0
  endif
  let l:m = mode()
  if l:m ==# 'v'
    if l:at_end
      return "\<Esc>l"
    else
      return "\<Esc>"
    endif
  elseif l:m ==# 'V'
    if l:at_end
      return "\<Esc>j"
    else
      return "\<Esc>"
    endif
  elseif l:m ==# "\<C-v>"
    " In block selection, consider to be "at end" if not in the first column
    " XXX: this rules may be confusing
    if l:c_num > l:c_num_oppos || (l:c_num == l:c_num_oppos && l:at_end)
      return "\<Esc>l"
    else
      return "\<Esc>"
    endif
  endif
endfunction
vnoremap <expr> <SID>key_<Esc> <SID>VMapExpr_EscKey()
onoremap <SID>key_<Esc> <Esc>
inoremap <SID>key_<Esc> <Esc>`^

if has('gui_running') || has('nvim')
  " XXX: remapping <Esc> breaks arrow keys in terminal Vim
  noremap  <script> <Esc> <SID>key_<Esc>
  inoremap <script> <Esc> <SID>key_<Esc>
endif

nnoremap <SID>key_g r
vnoremap <SID>key_g r
nnoremap <SID>key_G R
vnoremap <SID>key_G R

nnoremap <SID>key_c A
vnoremap <SID>key_c A
nnoremap <SID>key_x I
vnoremap <SID>key_x I
nnoremap <SID>key_C o
nnoremap <SID>key_X O
nnoremap <SID>2keyseq_'c g_a
nnoremap <SID>2keyseq_'x 0i
nnoremap <SID>2keyseq_'C o<C-u>
nnoremap <SID>2keyseq_'X O<C-u>

"
" #.#.# Use registers
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  `{a-zA-Z0-9.%#:-"} - use the given register (like `"` in Vim)
noremap <SID>key_` "

"
" #.#.# Small motions
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  j, <Left>  - left (`h` in Vim)
"  ;, <Right> - right (`l` in Vim)
"  l, <Up>    - up on screen (`gk` in Vim)
"  k, <Down>  - down on screen (`gj` in Vim)
"  'l         - up in text (`k` in Vim)
"  'k         - down in text (`j` in Vim)
"  <Space>    - in Operator-pending mode: one character right (`l` in Vim)
noremap <SID>key_j h
noremap <SID>key_; l
noremap <SID>key_l gk
noremap <SID>key_k gj
onoremap <Space> l

noremap <script> <Left>  <SID>key_j
noremap <script> <Right> <SID>key_;
noremap <script> <Up>    <SID>key_l
noremap <script> <Down>  <SID>key_k

noremap <SID>2keyseq_'l k
noremap <SID>2keyseq_'k j
" noremap <script> <A-Up>   <SID>2keyseq_'l
" noremap <script> <A-Down> <SID>2keyseq_'k

"
" #.#.# Big motions
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  i         - Normal mode: beginning of this or previous word (`b` in Vim)
"  I         - Normal mode: beginning of this or previous space-delimited
"              word (`B` in Vim)
"  ,         - Normal mode: after the end of the previous word
"  <         - Normal mode: after the end of the previous space-delimited
"              word
"  o         - Normal mode: beginning of the next word (`w` in Vim)
"  O         - Normal mode: beginning of the next space-delimited word
"              (`W` in Vim)
"  .         - Normal mode: after the end of this or next word
"  >         - Normal mode: after the end of this or next space-delimited
"              word
"  'j        - go to the first column of the line (`0`)
"  [count]', - go to the first non-blank of the previous line or
"              to the first non-blank of [count] line above (like `-`)
"  ';        - go to or after the last non-blank character of the line
"              (`g_` or `g_l`)
"  '.        - Normal mode: go to the first non-blank character of the
"              following line (`+`)
"  [count]J  - go to the first non-blank character of the line (`^`) if not
"              there already and if no count is given, otherwise act like
"              `+` in Vim (like `"O`)
"  [count]"J - go to the first column of the line (like `0` in Vim) or to
"              the first column of [count] line below
"  x         - Operator pending mode: duplicate of `J`
"  [count]:  - Normal mode: go after the last character of the line (`$l`),
"              unless already there and no [count] is given; if [count] is
"              given, act like `$l` in Vim, otherwise go after the end of
"              the following line;
"              Visual mode: go to the last character of the line (like `$h`
"              in Vim), unless already there or [count] is givent, etc.
"              Operator pending mode: a like `$` in Vim
"  [count]": - go to or after the first non-blank character of the line
"              (`g_l` or `g_` in Vim) (like `'l`), unless already there or
"              [count] is given; if [count] is given, also act abit like `g_`
"              in Vim, otherwise go to or after the last non-blank character
"              of the following line
"  c         - Operator pending mode: duplicate of `:`
"  [count]L  - `-` in Vim
"  [count]K  - `+` in Vim
"  {         - beginning of the first line of this or previous paragraph
"  }         - Normal mode: beginning of the first line of the next
"              paragraph
"              Visual mode: beginning of the last line of this or
"              next paragraph
"  [count]'< - go to the first column of the previous line or
"              to the first column of [count] line above
"              (a bit like `-0` in Vim)
"  [count]'i  - go after the end of the previous line (`-`) or
"              after the end of [count] line above
"              (a bit like `-$` in Vim)
"  [count]"I - go after the last non-blank of the previous line or
"              after the last non-blank of [count] line above
"              (a bit like `-g_` in Vim)
"  <C-Left>  - move one word left (like the default, or like in Emacs)
"  <C-Right> - move one word right (like the default, or like in Emacs)
"  <S-Left>  - duplicate of `I`
"  <S-Right> - duplicate of `O`
"  <S-Up>    - duplicate of `{`
"  <S-Down>  - duplicate of `}`
"
"  The following are currently disabled:
"
"    <A-Left>  - duplicate of `';`
"    <A-Right> - duplicate of `'l`
"    <S-A-Left>  - duplicate of `":`
"    <S-A-Right> - duplicate of `"L`
nmap <SID>key_, <Plug>(CrazyKeys-NO_ToEndOfWordBackward)
omap <SID>key_, <Plug>(CrazyKeys-NO_ToEndOfWordBackward)
vmap <SID>key_, <Plug>(CrazyKeys-V_ToEndOfWordBackward)
nmap <SID>key_< <Plug>(CrazyKeys-NO_ToEndOfSpacedWordBackward)
omap <SID>key_< <Plug>(CrazyKeys-NO_ToEndOfSpacedWordBackward)
vmap <SID>key_< <Plug>(CrazyKeys-V_ToEndOfSpacedWordBackward)
nmap <SID>key_. <Plug>(CrazyKeys-NO_ToEndOfWordForward)
omap <SID>key_. <Plug>(CrazyKeys-NO_ToEndOfWordForward)
vmap <SID>key_. <Plug>(CrazyKeys-V_ToEndOfWordForward)
" vnoremap <SID>key_. e
nmap <SID>key_> <Plug>(CrazyKeys-NO_ToEndOfSpacedWordForward)
omap <SID>key_> <Plug>(CrazyKeys-NO_ToEndOfSpacedWordForward)
vmap <SID>key_> <Plug>(CrazyKeys-V_ToEndOfSpacedWordForward)
" vnoremap <SID>key_> E
" noremap <SID>key_i b
nmap <SID>key_i <Plug>(CrazyKeys-NO_ToStartOfWordBackward)
omap <SID>key_i <Plug>(CrazyKeys-NO_ToStartOfWordBackward)
vmap <SID>key_i <Plug>(CrazyKeys-V_ToStartOfWordBackward)
" noremap <SID>key_I B
nmap <SID>key_I <Plug>(CrazyKeys-NO_ToStartOfSpacedWordBackward)
omap <SID>key_I <Plug>(CrazyKeys-NO_ToStartOfSpacedWordBackward)
vmap <SID>key_I <Plug>(CrazyKeys-V_ToStartOfSpacedWordBackward)
" nnoremap <SID>key_o w
" onoremap <SID>key_o w
nmap <SID>key_o <Plug>(CrazyKeys-NO_ToStartOfWordForward)
omap <SID>key_o <Plug>(CrazyKeys-NO_ToStartOfWordForward)
vmap <SID>key_o <Plug>(CrazyKeys-V_ToStartOfWordForward)
" vnoremap <SID>key_o @=" w\<lt>BS>"<CR>
" nnoremap <SID>key_O W
" onoremap <SID>key_O W
nmap <SID>key_O <Plug>(CrazyKeys-NO_ToStartOfSpacedWordForward)
omap <SID>key_O <Plug>(CrazyKeys-NO_ToStartOfSpacedWordForward)
vmap <SID>key_O <Plug>(CrazyKeys-V_ToStartOfSpacedWordForward)
" vnoremap <SID>key_O @=" w\<lt>BS>"<CR>
noremap <script> <S-Left>  <SID>key_I
noremap <script> <S-Right> <SID>key_O

noremap <SID>2keyseq_'j 0
noremap  <SID>2keyseq_', -
onoremap <SID>2keyseq_', v-

nnoremap <SID>2keyseq_'; g_l
" FIXME: include the last non-blank character when moving from the left,
"   exclude when moving from the right
vnoremap <SID>2keyseq_'; g_
" FIXME: same
onoremap <SID>2keyseq_'; g_
noremap  <SID>2keyseq_'. +
onoremap <SID>2keyseq_'. v+

map <SID>key_J <Plug>(CrazyKeys-ToFirstNonblankThisOrNext)
onoremap <script> <SID>key_x <SID>key_J

map <SID>2keyseq_'J <Plug>(CrazyKeys-ToFirstColumnThisOrNext)

" function! s:NMapExpr_ToEndOfThisOrNextLine()
"   if v:count
"     return '$l'
"   else
"     let [@_, l:l_num, l:c_num, @_] = getpos('.')
"     if l:c_num == len(getline(l:l_num)) + 1
"       return '+$l'
"     else
"       return '$l'
"     endif
"   endif
" endfunction
" function! s:VMapExpr_ToEndOfThisOrNextLine()
"   let [@_, l:l_num, l:c_num, @_] = getpos('.')
"   let [@_, l:l_num_oppos, l:c_num_oppos, @_] = getpos('v')
"   if v:count
"     let l:l_num += v:count - 1
"     let l:c_num_last_nonblank = len(getline(l:l_num))
"     if (l:l_num_oppos < l:l_num) ||
"           \ (l:l_num_oppos == l:l_num &&
"           \  l:c_num_oppos <= l:c_num_last_nonblank)
"       return '$h'
"     else
"       return '$'
"     endif
"   else
"     let l:c_num_last_nonblank = len(getline(l:l_num))
"     if (l:l_num_oppos < l:l_num) ||
"           \ (l:l_num_oppos == l:l_num &&
"           \  l:c_num_oppos <= l:c_num_last_nonblank)
"       if l:c_num == l:c_num_last_nonblank
"         return '2$h'
"       else
"         return '$h'
"       endif
"     else
"       if l:c_num == l:c_num_last_nonblank + 1
"         let l:l_num += 1
"         let l:c_num_last_nonblank = len(getline(l:l_num))
"         if (l:l_num_oppos < l:l_num) ||
"               \ (l:l_num_oppos == l:l_num &&
"               \  l:c_num_oppos <= l:c_num_last_nonblank)
"           return '2$h'
"         else
"           return '2$'
"         endif
"       else
"         return '$'
"       endif
"     endif
"   endif
" endfunction
" nnoremap <expr> <SID>key_: <SID>NMapExpr_ToEndOfThisOrNextLine()
" vnoremap <expr> <SID>key_: <SID>VMapExpr_ToEndOfThisOrNextLine()
" onoremap <SID>key_: $
nmap <SID>key_: <Plug>(CrazyKeys-NO_ToEndOfThisOrNextLine)
omap <SID>key_: <Plug>(CrazyKeys-NO_ToEndOfThisOrNextLine)
vmap <SID>key_: <Plug>(CrazyKeys-V_ToEndOfThisOrNextLine)
onoremap <script> <SID>key_c <SID>key_:

function! s:NMapExpr_ToLastNonblankOfThisOrNextLine()
  if v:count
    return 'g_l'
  else
    let [@_, l:l_num, l:c_num, @_] = getpos('.')
    if l:c_num == match(getline(l:l_num), '\s*$') + 1
      return '+g_l'
    else
      return 'g_l'
    endif
  endif
endfunction
function! s:VMapExpr_ToLastNonblankOfThisOrNextLine()
  let [@_, l:l_num, l:c_num, @_] = getpos('.')
  let [@_, l:l_num_oppos, l:c_num_oppos, @_] = getpos('v')
  let l:count = v:count
  if l:count
    let l:l_num += l:count - 1
    let l:c_num_last_nonblank = match(getline(l:l_num), '\s*$')
    if (l:l_num_oppos < l:l_num) ||
          \ (l:l_num_oppos == l:l_num &&
          \  l:c_num_oppos <= l:c_num_last_nonblank)
      return 'g_'
    else
      return 'g_l'
    endif
  else
    let l:c_num_last_nonblank = match(getline(l:l_num), '\s*$')
    if (l:l_num_oppos < l:l_num) ||
          \ (l:l_num_oppos == l:l_num &&
          \  l:c_num_oppos <= l:c_num_last_nonblank)
      if l:c_num == l:c_num_last_nonblank
        return '2g_'
      else
        return 'g_'
      endif
    else
      if l:c_num == l:c_num_last_nonblank + 1
        let l:l_num += 1
        let l:c_num_last_nonblank = match(getline(l:l_num), '\s*$')
        if (l:l_num_oppos < l:l_num) ||
              \ (l:l_num_oppos == l:l_num &&
              \  l:c_num_oppos <= l:c_num_last_nonblank)
          return '2g_'
        else
          return '2g_l'
        endif
      else
        return 'g_l'
      endif
    endif
  endif
endfunction
function! s:OMapExpr_ToLastNonblankOfThisOrNextLine()
  if v:count
    return 'g_'
  else
    let [@_, l:l_num, l:c_num, @_] = getpos('.')
    let l:c_num_after_last_nonblank = match(getline(l:l_num), '\s*$') + 1
    if l:c_num == l:c_num_after_last_nonblank
      return '2g_'
    elseif l:c_num < l:c_num_after_last_nonblank
      return 'g_'
    else
      " FIXME: should not include the last nonblank character
      return 'g_'
    endif
  endif
endfunction
nnoremap <expr> <SID>2keyseq_': <SID>NMapExpr_ToLastNonblankOfThisOrNextLine()
vnoremap <expr> <SID>2keyseq_': <SID>VMapExpr_ToLastNonblankOfThisOrNextLine()
onoremap <expr> <SID>2keyseq_': <SID>OMapExpr_ToLastNonblankOfThisOrNextLine()

" noremap <script> <A-Left>   <SID>2keyseq_'j
" noremap <script> <S-A-Left> <SID>2keyseq_'J
" noremap <script> <A-Right>   <SID>2keyseq_';
" noremap <script> <S-A-Right> <SID>2keyseq_':

noremap <SID>key_L -
noremap <SID>key_K +

noremap  <SID>key_{ @="k{ ^"<CR>
onoremap <SID>key_{ {
" TODO: test and/or improve this
nnoremap <SID>key_} }}k{<Space>^
vnoremap <SID>key_} @="j}\<lt>BS>^"<CR>
onoremap <SID>key_} }
noremap <script> <S-Up>   <SID>key_{
noremap <script> <S-Down> <SID>key_}

nnoremap <SID>2keyseq_'< -0
vnoremap <SID>2keyseq_'< -0
" FIXME: implement
onoremap <SID>2keyseq_'< <Nop>
nnoremap <SID>2keyseq_'i -$l
vnoremap <SID>2keyseq_'i -$h
" FIXME: implement
onoremap <SID>2keyseq_'i <Nop>
nnoremap <SID>2keyseq_'I -g_l
vnoremap <SID>2keyseq_'I -g_
" FIXME: implement
onoremap <SID>2keyseq_'I <Nop>

noremap <C-Left>  <C-Left>
noremap <C-Right> <C-Right>

"
" #.#.# Window-based motions
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  __ - to line [count] from top of window (default: first line on
"        the window) on the first non-blank character linewise (`H`)
"  _- - to line [count] from bottom of window (default: first
"        line on the window) on the first non-blank character linewise (`L`)
"  _= - to middle line of window, on the first non-blank character
"        linewise (`M`)
noremap <SID>2keyseq___ H
noremap <SID>2keyseq__- L
noremap <SID>2keyseq__= M

"
" #.#.# Text object motions
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  Some ideas:
"  (  - beginning of the sentence `(`
"  )  - end of the sentence `)`
"  '[ - ?
"  '] - ?
"  [[ - `[[`
"  ]] - `]]`
"  ][ - `][`
"  [] - `[]`

" TODO: test this
noremap <SID>key_( (
noremap <SID>key_) )
noremap <SID>2keyseq_[[ [[
noremap <SID>2keyseq_]] ]]
noremap <SID>2keyseq_[] []
noremap <SID>2keyseq_][ ][
" TODO: make most mappings with the `[` and `]` prefixes work as in the
"   "unimpaired" plugin

"
" #.#.# Visual mode special mappings
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  00 - Visual mode: go to the opposite end of the selection
"       (`o` in Vim)
" TODO:  Think how to map `--` and `==` to this or something similar.
"   Note the mappings for `-` and `=`.
vnoremap <SID>2keyseq_00 o
" vnoremap <script> <SID>2keyseq_-- <SID>2keyseq_'h

"
" #.#.# Undo/redo
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  b     - undo
"  B     - redo
nnoremap <SID>key_b u
vnoremap <SID>key_b u
nnoremap <SID>key_B <C-r>
vnoremap <SID>key_B <C-r>

"
" #.#.# Macros
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  ~     - start/stop recording a macro (`q`)
"  <C-q> - start/stop recording a macro to the unnamed register (`q"`)
"  @     - execute a macro (`@`)
"  <C-a> - execute the last executed macro (`@@`) or the macro in
"          the unnamed register (`@"`)
nnoremap <SID>key_~ q
vnoremap <SID>key_~ q

function! s:NVMapEReg_RecordOrStopRecordingToUnnamedRegister()
  " FIXME!
  return 'q'
endfunction

nnoremap <C-q> @=<SID>NVMapEReg_RecordOrStopRecordingToUnnamedRegister()<CR>
vnoremap <C-q> @=<SID>NVMapEReg_RecordOrStopRecordingToUnnamedRegister()<CR>
nnoremap <SID>key_@ @
vnoremap <SID>key_@ @

function! s:NVMapEReg_RunLastMacroOrUnnamedRegister()
  " FIXME!
  return '@"'
endfunction

nnoremap <C-a> @=<SID>NVMapEReg_RunLastMacroOrUnnamedRegister()<CR>
vnoremap <C-a> @=<SID>NVMapEReg_RunLastMacroOrUnnamedRegister()<CR>

"
" #.#.# Repeating operations
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  v - repeat last edit (`.`)
"  V - repeat last macro (`@@`)
"  $ - repeat last substitute (`&`)
"  # - repeat last colon command (`@:`)
"  NOTE: consider assigning this operation to some Control-key instead.
"  TODO: think about a single key to repeat last macro (`@@`)
"  TODO: make `n` and `N` repeat the last motion which does not have a
"    single-key mapping (may be hard to implement)
nnoremap <SID>key_v .
vnoremap <SID>key_v .
nnoremap <SID>key_V @@
vnoremap <SID>key_V @@
nnoremap <SID>key_$ &
vnoremap <SID>key_$ &
nnoremap <SID>key_# @:
vnoremap <SID>key_# @:

"
" #.#.# Goto
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  [count]-  - with [count]: go to line number [count] (`gg` in Vim);
"  -         - without [count]: go to the first non-blank character of the
"              mark line (`'` in Vim)
"  [count]'- - go to line number [count] from the bottom
"  0-        - go to the last line
"  [count]=  - with [count]: go to column number [count] in the current
"              line
"  =           without [count]: go to the mark (`\(backquote)` in Vim)
"  [count]'= - go to [count] characters before the end of the line
"  0=        - go to the end of the line
"  *         - go to the matching parenthesis-like delimiter (like `%`) or
"              cycle forward through matching keywords like if-then-else
"              (like `%` with "matchit" plugin)
"  '*        - go to the matching parenthesis-like delimiter (like `%`) or
"              cycle backward through matching keywords like if-then-else
"              (like `g%` with "matchit" plugin)
"  <C-o>, <S-Tab> - "back", go to the previous position (`<C-o>`)
"  <C-i>, <Tab>   - return "forward", go to the next position (`<C-i>`)
noremap <expr> <SID>key_- (v:count?'gg':'''')
" FIXME: make use [count] as specified
noremap <SID>2keyseq_'- G
noremap <SID>2keyseq_0- G
noremap <expr> <SID>key_= (v:count?'<bar>':'`')

function! s:VMapExpr_GoToColumn(count)
  let l:l_num = line('.')
  let [@_, l:l_num_oppos, l:c_num_oppos, @_] = getpos('v')
  if (l:l_num_oppos < l:l_num) ||
        \ (l:l_num_oppos == l:l_num &&
        \  l:c_num_oppos <= a:count)
    let l:c_num = a:count - 1
  else
    let l:c_num = a:count
  endif
  if l:c_num <= 1
    return '0'
  else
    " NOTE: the `'@_'` part is used to cancel the count, i am not aware of
    "   any better way
    return '@_' . l:c_num . '|'
  endif
endfunction
vnoremap <expr> <SID>key_= (v:count?s:VMapExpr_GoToColumn(v:count):'`')
"
" FIXME: make use [count] as specified
noremap <script> <SID>2keyseq_'= <SID>key_L
noremap <script> <SID>2keyseq_0= <SID>key_L

" XXX: this uses an unstable version of "matchit" plugin, see
"   https://github.com/benjifisher/matchit.zip
nmap <SID>key_* <Plug>MatchItNormalForward
vmap <SID>key_* <Plug>MatchItVisualForward
omap <SID>key_* <Plug>MatchItOperationForward
nmap <SID>2keyseq_'* <Plug>MatchItNormalBackward
vmap <SID>2keyseq_'* <Plug>MatchItVisualBackward
omap <SID>2keyseq_'* <Plug>MatchItOperationBackward

noremap <C-o>   <C-o>
noremap <S-Tab> <C-o>
noremap <C-i>   <C-i>
noremap <Tab>   <C-i>

"
" #.#.# Go to a character
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  /  - in Normal mode: go to a character forward (like `f` in Vim)
"  /  - in Visual and Operator modes: go to a character forward
"       (like `f` in Vim)
"  '/ - in Normal mode: go to a character forward and stop just after it
"  '/ - in Visual and Operator modes: go to a character forward and stop
"       just before it (like `t` in Vim)
"  ?  - in Normal mode: go to a character back (like `F` in Vim)
"  ?  - in Visual and Operator modes: go to a character back
"       (like `F` in Vim)
"  "? - in Normal mode: go to a character back and stop just after it
"       (like `T` in Vim)
"  "? - in Visual and Operator modes: go to a character back and stop just
"       after it (like `T` in Vim)
"  m  - repeat in the same direction (roughly `;` in Vim)
"  M  - repeat in the opposite direction (roughly `,` in Vim)
"
" Use smart case by default
"
" TODO: make `m` and `M` repeat the last motion which is not a
"   single-key mapping (may be hard to implement)
"
" XXX: this uses "vim-extended-ft" plugin
" FIXME: this does not work correctly in Visual mode
" TODO: rewrite without using the buggy "vim-extended-ft"
nmap <SID>key_/ <Plug>ExtendedFtSearchFForward
vmap <SID>key_/ <Plug>ExtendedFtVisualModeSearchFForward
omap <SID>key_/ <Plug>ExtendedFtOperationModeSearchFForward
nmap <SID>key_? <Plug>ExtendedFtSearchFBackward
vmap <SID>key_? <Plug>ExtendedFtVisualModeSearchFBackward
omap <SID>key_? <Plug>ExtendedFtOperationModeSearchFBackward
" FIXME: make it go just *after* the character
" NOTE: it is probably necessary to copy-paste and edit definitions from
"   "vim-extended-ft"
nmap <SID>2keyseq_'/ <Plug>ExtendedFtSearchFForward
vmap <SID>2keyseq_'/ <Plug>ExtendedFtVisualModeSearchTForward
omap <SID>2keyseq_'/ <Plug>ExtendedFtOperationModeSearchTForward
nmap <SID>2keyseq_'? <Plug>ExtendedFtSearchTBackward
vmap <SID>2keyseq_'? <Plug>ExtendedFtVisualModeSearchTBackward
omap <SID>2keyseq_'? <Plug>ExtendedFtOperationModeSearchTBackward

nmap <SID>key_m <Plug>ExtendedFtRepeatSearchForward
vmap <SID>key_m <Plug>ExtendedFtVisualModeRepeatSearchForward
omap <SID>key_m <Plug>ExtendedFtOperationModeRepeatSearchForward
nmap <SID>key_M <Plug>ExtendedFtRepeatSearchBackward
vmap <SID>key_M <Plug>ExtendedFtVisualModeRepeatSearchBackward
omap <SID>key_M <Plug>ExtendedFtOperationModeRepeatSearchBackward

"
" #.#.# Marks
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  +  - set a mark (`m`)
"  ++ - set the mark `\(backquote)`
"  =  - go to the mark (see "Goto" section)
"  -  - go to the first non-blank character of the mark line (see "Goto"
"       section)
nnoremap <SID>key_+ m
vnoremap <SID>key_+ m
nnoremap <SID>2keyseq_++ m`
vnoremap <SID>2keyseq_++ m`

"
" #.#.# Find
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  p   - find forward (`/`)
"  P   - find backward (`?`)
"  'p  - find forward with search window (`q/`)
"  'P  - find backward with search window (`q?`)
"  &   - find next occurrence of the current word (`*`)
"  ^   - find previous occurrence of the current word (`#`)
"  '&  - find next occurrence of the current word as a part of a word
"        (`g*`)
"  '^  - find previous occurrence of the current word as a part of a word
"        (`g#`)
"  u   - repeat last find in the same direction (`n`)
"  U   - repeat last find in the opposite direction (`N`)
"  'u  - go to the next match and select it with Visual mode (`gn` in Vim)
"  'U  - go to the previous match and select it with Visual mode
"        (`gN` in Vim)
noremap <SID>key_p /
noremap <SID>key_P ?
nnoremap <SID>2keyseq_'p q/
vnoremap <SID>2keyseq_'p q/
nnoremap <SID>2keyseq_'P q?
vnoremap <SID>2keyseq_'P q?
noremap <SID>key_& *
noremap <SID>2keyseq_'& g*
noremap <SID>key_^ #
noremap <SID>2keyseq_'^ g#
noremap <SID>key_u n
noremap <SID>key_U N
noremap <SID>2keyseq_'u gn
noremap <SID>2keyseq_'U gN

"
" #.#.# Find and replace (substitute)
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  %  - replace
"  '% - replace the last search with ...
nnoremap <SID>key_% :%s///<Left><Left>
vnoremap <SID>key_% :s///<Left><Left>
nnoremap <SID>2keyseq_'% :%s/<C-r>///<Left>
vnoremap <SID>2keyseq_'% :s/<C-r>///<Left>

"
" #.#.# Editing
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
" NOTE: the roles of <Del> and <BS> may be inverted in Normal mode
"  r         - in Normal mode: delete a single character
"              on the right of the cursor without copying to the register
"              (`"_x` in Vim),
"              in Visual mode: delete the selection without copying
"              to the register (`"_d`)
"  R         - in Normal mode: delete a single character
"              on the left of the cursor without copying to the register
"              (`"_X` in Vim),
"              in Visual mode: delete the entire lines that have something
"              selected without copying to the register (`V"_d`)
"  <Del>     - delete a single character to the left without copying
"              to the register (`"_X` in Vim)
"  <S-Del>   - delete a single character at/after the cursor without copying
"              to the register (`"_x` in Vim)
"  a{motion} - in Normal mode: copy `y`
"  a         - in Visual mode: copy and move cursor to the opposite end of
"              the yanked block (to the beginning or just after it)
"  'a        - in Visual mode: copy without moving cursor, if the cursor is
"              in the beginning, and move it just after the yanked block
"              if it is at the end of the selected block
"  <Space>   - in Visual mode: same as `'a`
"  [count]aa - in Normal mode: `yy`
"  [count]A  - in Normal mode: yank [count] lines and jump over them
"  A         - in Visual mode: yank and restore the selection (`ygv`)
"  [count]"A  - in Normal mode: yank [count] lines above
"  [count]'aa - in Normal mode: yank [count] lines above and jump to the
"              first yanked line
"  ""A       - in Normal mode: yank the current line without indent, without
"              trailing whitespace, and without new line characters
"  <S-Space> - in visual mode: yank and restore the selection (`ygv`,
"              same as `A`)
"  s         - in Normal mode (character-wise only): paste before (`gP`)
"              in Visual mode: replace without changing the unnamed register
"              (not like `p`) and put the cursor after the pasted text
"  's        - in Normal mode:
"              for character-wise and block-wise pasting, same as `s`;
"              for line-wise pasting, paste after the current line and move
"              the cursor after the pasted text
"  ``s       - in Visual mode: replace with replacing the content of the
"              unnamed register with the replaces text (`p` or `P`)
"              and put the cursor after the pasted text
"  S         - in Normal mode:
"              for character-wise and block-wise pasting, paste "at"/"before"
"              the cursor without moving the cursor, that is leaving the
"              cursor at the beginning of the pasted text;
"              for line-wise pasting, paste before the current line and put
"              the cursor at the beginning of the pasted text;
"              in Visual mode: replace, without changing the unnamed
"              register (not like `p`) and go to the beginning of the pasted
"              text
"  "S        - in Normal mode:
"              for character-wise and block-wise pasting, same as `S`;
"              for line-wise pasting, paste after the current line and move
"              the cursor to the beginning of the pasted text
"  ``S       - in Visual mode: replace with replacing the content of the
"              unnamed register with the replaces text (`p` or `P`)
"              and go to the beginning of the pasted text
"  d{motion} - `d`
"  dd        - in Normal mode: `dd`
"  [count]D  - in Normal mode: delete [count] lines before the current line,
"              in Visual mode: delete the entire lines that have something
"              selected (`Vd`)
"  'd{motion}  - same as `d` but without copying to the register (`"_d`)
"  <BS>{motion}  - same as `d{motion}` but without copying to the register
"              (`"_d`)
"  <BS><BS>  - same as `dd` but without copying to the register (`"_x`)
"  <S-BS>    - same as `D` but without copying to the register
"  f{motion} - `"_c`
"  ff        - `"_cc`
"  [count]F  - Normal mode: replace count previous lines,
"              Visual mode: `V"_cc`
"  af        - Normal mode: `c`
"  aF        - `cc`
"  TODO:
"    Define some key combinations for `:diffget` and `:diffput` in diff
"    mode.  Probably, use `d` or `g` key as the first key.
nnoremap <SID>key_r "_x
vnoremap <SID>key_r "_d
nnoremap <SID>key_R "_X
vnoremap <SID>key_R V"_d
nnoremap <S-Del> "_x
vnoremap <S-Del> V"_d
nnoremap <SID>key_a y
vnoremap <script> <SID>key_a ygvo<SID>key_<Esc>
nnoremap <SID>2keyseq_aa yy
" FIXME: make yank the lines above
nnoremap <SID>3keyseq_'aa yy'[
vnoremap <script> <SID>2keyseq_'a ygv<SID>key_<Esc>
nnoremap <SID>key_A yy']j
vnoremap <SID>key_A ygv
" FIXME: make yank the lines above
nnoremap <SID>2keyseq_'A yy
" FIXME: make work with [count]
nnoremap <SID>3keyseq_''A m`^yg_``
vnoremap <script> <Space>   <SID>2keyseq_'a
vnoremap <script> <S-Space> <SID>key_A

function! s:NMapEReg_PasteBeforeV1()
  let l:reg_name = v:register
  let l:reg_type = getregtype(l:reg_name)
  if l:reg_type ==# 'V'
    return 'm`"' . l:reg_name . 'P``'
  else
    return '"' . l:reg_name . 'gP'
  endif
endfunction
nnoremap <SID>key_s @=<SID>NMapEReg_PasteBeforeV1()<CR>
vnoremap <SID>key_s "_dgP
function! s:NMapEReg_PasteAfterV1()
  let l:reg_name = v:register
  let l:reg_type = getregtype(l:reg_name)
  if l:reg_type ==# 'V'
    return '"' . l:reg_name . 'gp'
  else
    return '"' . l:reg_name . 'gP'
  endif
endfunction
nnoremap <SID>2keyseq_'s @=<SID>NMapEReg_PasteAfterV1()<CR>
vnoremap <SID>3keyseq_``s gP
" function! s:NMapEReg_PasteBeforeV2()
"   let l:reg_name = v:register
"   let l:reg_type = getregtype(l:reg_name)
"   if l:reg_type ==# 'V'
"     return '"' . l:reg_name . 'P'
"   else
"     return '"' . l:reg_name . 'P`['
"   endif
" endfunction
" nnoremap <SID>key_S @=<SID>NMapEReg_PasteBeforeV2()<CR>
nnoremap <SID>key_S P`[
vnoremap <SID>key_S "_dP`[
function! s:NMapEReg_PasteAfterV2()
  let l:reg_name = v:register
  let l:reg_type = getregtype(l:reg_name)
  if l:reg_type ==# 'V'
    return '"' . l:reg_name . 'p'
  else
    return '"' . l:reg_name . 'P`['
  endif
endfunction
nnoremap <SID>2keyseq_'S @=<SID>NMapEReg_PasteAfterV2()<CR>
vnoremap <SID>3keyseq_``S P`[

nnoremap <SID>key_d d
vnoremap <SID>key_d d
" nnoremap <expr> <SID>key_D ':<C-u>-' . v:count1 . ',-1d<CR>'
nmap <SID>key_D <Plug>(CrazyKeys-N_CutLinesAbove)
vnoremap <SID>key_D Vd
nnoremap <SID>2keyseq_dd dd
nnoremap <SID>2keyseq_'d "_d
vnoremap <SID>2keyseq_'d "_d
nnoremap <SID>2keyseq_rr "_x
nnoremap <BS> "_d
vnoremap <BS> "_d
" FIXME: when on the first line of a file, this deletes the current line
" nnoremap <expr> <S-BS> ':<C-u>-' . v:count1 . ',-1d _<CR>'
nmap <S-BS> <Plug>(CrazyKeys-N_DeleteLinesAbove)
vnoremap <S-BS> V"_d
nnoremap <BS><BS> "_dd
onoremap <BS> <Esc>
nnoremap <Del> "_X
vnoremap <Del> "_d
onoremap <Del> <Esc>

nnoremap <SID>key_f "_c
vnoremap <SID>key_f "_c
nnoremap <expr> <SID>key_F ':<C-u>-' . v:count1 . ',-1d _<CR>O'
vnoremap <SID>key_F V"_cc
nnoremap <SID>2keyseq_ff "_cc
nnoremap <SID>2keyseq_af c
vnoremap <SID>2keyseq_af c
nnoremap <SID>3keyseq_aff cc
" FIXME: make behave like `F`, but with a register
nnoremap <SID>2keyseq_aF cc
vnoremap <SID>2keyseq_'F Vcc

"
" #.#.# Change case
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  t  - Normal mode: Switch case of the character under the cursor and
"       move the cursor to the right (`~` in Vim);
"       Visual mode: downcase (`gu` in Vim)
"  T  - Normal mode: Switch case of the character under the cursor and
"       make the rest of the word the same case;
"       Visual mode: up (`gU` in Vim)
"  't{motion} - Normal mode: downcase over the {motion} (like `gu` in Vim)
"  "T{motion} - Normal mode: upcase over the {motion} (like `gU` in Vim)
nnoremap <SID>key_t ~
vnoremap <SID>key_t gu
function! s:NMapExpr_ChangeCaseTillEOW()
  let l:char = getline('.')[col('.') - 1]
  if toupper(l:char) !=# l:char
    return 'gUe'
  elseif tolower(l:char) !=# l:char
    return 'gue'
  elseif
    return "\<Nop>"
  endif
endfunction
nnoremap <expr> <SID>key_T <SID>NMapExpr_ChangeCaseTillEOW()
vnoremap <SID>key_T gU
nnoremap <SID>2keyseq_'t gu
nnoremap <SID>2keyseq_'T gU

"
" #.#.# Running external programs
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  ! - filter text lines through a given external program ('!').
nnoremap <SID>key_! !
vnoremap <SID>key_! !

"
" #.#.# Indent/unindent
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  q - indent
"  Q - un-indent
nnoremap <SID>key_q >>
vnoremap <SID>key_q >gv
nnoremap <SID>key_Q <<
vnoremap <SID>key_Q <gv
" nnoremap <SID>key_q :PPi<CR>
" vnoremap <SID>key_q :PPi<CR>
" nnoremap <SID>key_Q :PPI<CR>
" vnoremap <SID>key_Q :PPI<CR>

"
" #.#.# Commenting/uncommenting
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  'q - comment/uncomment the line or selection
" XXX: this relies on "tComment" plugin
nnoremap <SID>2keyseq_'q :TComment<CR>
" vnoremap <SID>2keyseq_'q :TComment<CR>gv
vnoremap <SID>2keyseq_'q :TComment<CR>

"
" #.#.# Auto-formatting
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  "Q - reformat
nnoremap <SID>2keyseq_'Q gq
vnoremap <SID>2keyseq_'Q gq

"
" #.#.# Insert space
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  w  - insert a space before the cursor
"  e  - insert a space before the cursor, leaving the cursor at the
"       beginning of the inserted space
"  W  - insert a blank line before the current
"  E  - insert a blank line before the current and leave the cursor on the
"       inserted line
" NOTE:  Consider using <Ctrl-> keys instead if simple keys are needed
"   elsewhere.  These keys may be designated as of "minor importance" and
"   be safely assigned new functions when Vim is launched as a tool from
"   other applications.
" NOTE: it might be nice to have these mappings more or less consistent with
"   the ones for pasting (`key_d`, `key_D`, etc.)
nnoremap <SID>key_w i<Space><Esc>l
" nnoremap <SID>key_e @="i \<lt>Esc>`["<CR>
nnoremap <SID>key_e i<Space><Esc>`[
nnoremap <SID>key_W @="m`O\<lt>Esc>``"<CR>
nnoremap <SID>key_E @="O\<lt>Esc>"<CR>

"
" #.#.# Join/break lines
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  zz  - Normal mode: break the line before the current symbol
"  zZ  - Normal mode: break the line before the current symbol, leave the
"        cursor after/on the linebreak
"  'zz - Normal mode: break the line before the current symbol without space
"  'zZ - Normal mode: break the line before the current symbol without space,
"        leave the cursor after/on the linebreak
"  Z   - Normal mode: join this line with the next (`Jw`)
"  Z   - Visual mode: join lines (`J`)
"  "Z  - Normal mode: join this line with the next without space (`gJw`)
"  "Z  - Visual mode: join lines without space (`gJ`)
"  ""Z - Normal mode: join this line with the next one removing any space in
"        between (`@_Jdw`)
"  ""Z - Visual mode: join lines removing any space in between
" TODO: implement this
"  zz  - Visual mode: break the line at the current edge of selection
"  zZ  - Visual mode: break the line at the current edge of selection without
"        space
nnoremap <SID>key_z <Nop>
nnoremap <script> <SID>2keyseq_zZ i<CR><SID>key_<Esc>0<BS>l
nnoremap <script> <SID>2keyseq_zz i<CR><SID>key_<Esc>
" FIXME: the following 2 mappings seem broken in some situations
nnoremap <script> <SID>3keyseq_'zz i<CR><C-w><SID>key_<Esc>
nnoremap <script> <SID>3keyseq_'zZ i<CR><C-w><SID>key_<Esc>0<BS>l
nnoremap <SID>key_Z Jw
nnoremap <SID>2keyseq_'Z gJw
nnoremap <SID>3keyseq_''Z @_Jdw

vnoremap <SID>key_z <Nop>
vnoremap <SID>key_Z J
vnoremap <SID>2keyseq_'Z gJ
" TODO: implement
vnoremap <SID>3keyseq_''Z <Nop>

"
" #.#.# Scrolling
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  Most are same as in Vim for now:
"  <Ctrl-E>
"  <Ctrl-Y>
"  <Ctrl-D>
"  <Ctrl-U>
"  <Ctrl-F>
"  <Ctrl-B>
"
"  See also the mappings of <Space>, <S-Space>, <C-Space>, and <C-S-Space>
"  in the section about changing modes.
"
"  ''j       - scroll the current line to the middle (`zz`)
"  ''k, <S-A-Down> - scroll the current line to the top (`zt`)
"  ''l, <S-A-Up>   - scroll the current line to the bottom (`zb`)
nnoremap <C-d> <C-d>
vnoremap <C-d> <C-d>
nnoremap <C-u> <C-u>
vnoremap <C-u> <C-u>
nnoremap <C-f> <C-f>
vnoremap <C-f> <C-f>
nnoremap <C-b> <C-b>
vnoremap <C-b> <C-b>

nnoremap <C-Up> <C-u>
vnoremap <C-Up> <C-u>
nnoremap <C-Down> <C-d>
vnoremap <C-Down> <C-d>
noremap <C-e> <C-e>
noremap <C-y> <C-y>
nnoremap <SID>3keyseq_''j zz
vnoremap <SID>3keyseq_''j zz
nnoremap <SID>3keyseq_''l zt
vnoremap <SID>3keyseq_''l zt
nnoremap <SID>3keyseq_''k zb
vnoremap <SID>3keyseq_''k zb
noremap <script> <S-A-Up>   <SID>3keyseq_''l
noremap <script> <S-A-Down> <SID>3keyseq_''k

" Other interesting scroll commands
" * scroll one line down and go to the first non-blanck character of
"   the next line: @="1\<lt>C-D>"<CR>:set scroll=0<CR>
" * scroll one line up and go to the first non-blank character of the
"   previous line: @="1\<lt>C-U>"<CR>:set scroll=0<CR>

"
" #.#.# Folds
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
" y  - `zo`
" Y  - `zc`
" TODO: map 'y to more complex operations
nnoremap <SID>key_y zo
vnoremap <SID>key_y zo
nnoremap <SID>key_Y zc
vnoremap <SID>key_Y zc

"
" #.#.# User keys
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"  <n,N> in right-handed layouts (<b,B> in left-handed) is reserved as
"  a key or prefix for user defined functions.
"  (Another alternative: <t,T> and <y,Y>.)
noremap <SID>key_n <Nop>
noremap <SID>key_N <Nop>

"
" #.# Insert mode mappings
" -------------------------------------------------------------------------
"
" NOTE:  Try to follow *Readline* or *tcsh* conventions (*vi* or *Emacs*
"   mode, why not) when possible.  See also `:h emacs-keys`.
"
" <C-b> go one character left
" <C-f> go one character right
inoremap <C-b> <Left>
inoremap <C-f> <Right>

" <C-k> - delete to the end of line
" NOTE: the default use of <C-k> in Insert mode in Vim is to enter
"   "digraphs"
inoremap <C-k> <C-o>D

" <C-Ins> - insert a "digraph" (`<C-k>` in Vim); hardly needed, but
"           let it be
inoremap <C-Ins> <C-k>

" <C-Enter>, <C-Return>, <S-Enter>, or <S-Return> inserts a line break
"   AFTER the cursor
inoremap <C-CR> <CR><Up><End>
inoremap <S-CR> <CR><Up><End>

" <C-m> inserts a line break
" XXX: <C-m> seems to be (mostly?) indistinguishable form <CR> to Vim:
"   remapping <C-m> affects <CR>
" XXX:  This line is commented out because there is some strange bug:
"   with this mapping in a startup script, newlines get inserted twice.
"   This seem to be caused by some extensions or configurations (not
"   reproducible when .vim directory is removed).
" inoremap <C-m> <C-m>

" <C-BS> deletes the previous word:
inoremap <C-BS> <C-w>

" <S-BS> delete the character after the cursor
inoremap <S-BS> <Del>

" <C-d> delete the character after the cursor
" NOTE:  The default Vim function of removing one shiftwidth of indent at
"   the start from the current line was also moderately useful.  It can be
"   assigned to `<C-A-Left>`
inoremap <C-d> <Del>

" <C-t> Insert the character which is below the cursor (`<C-e>` in Vim)
" NOTE:   the default Vim function of adding one shiftwidth of indent at
"   the start from the current line was also moderately useful.  It can be
"   assigned to `<C-A-Right>`
inoremap <C-t> <C-e>

" <C-a> go to the beginning of the line
" <C-e> go to the end of the line
inoremap <C-a> <C-o>^
inoremap <C-e> <End>

" <C-j> go to the end of line (same as <C-e>)
" NOTE: <C-j> seems to be a nice candidate for inserting a line break AFTER
"   the cursor, but this is already assigned to <S-CR>, and <C-j> is used in
"   UltiSnips to jump between tabstops, which ressembles a bit to jumping
"   to the end of line
inoremap <C-j> <End>

" NOTE: these are not as useful as i thought before:
" inoremap <C-Left>  <Esc><C-Left>
" inoremap <C-Right> <Esc><C-Right>
" inoremap <C-Up>    <Esc><C-Up>
" inoremap <C-Down>  <Esc><C-Down>

"
" #.# Command-line mode mappings
" -------------------------------------------------------------------------
"
" XXX:experimental
"
" Use <Esc> as a prefix for command line editing commands
cnoremap <Esc>      <C-c>
cnoremap <Esc><Esc> <C-c>
cnoremap <C-Esc>    <C-c>

" Cmdwin mappings
autocmd CmdwinEnter * nnoremap <buffer> <Esc>  <C-c>
autocmd CmdwinEnter * nnoremap <buffer> <C-CR> <C-c>
autocmd CmdwinEnter * nnoremap <buffer> <S-CR> <C-c>
autocmd CmdwinEnter * noremap  <buffer> <C-c> <C-\><C-n>
autocmd CmdwinEnter * inoremap <buffer> <C-c> <Esc><C-\><C-n>
autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>
autocmd CmdwinEnter * vnoremap <buffer> <CR> <CR>

" <C-CR>, <S-CR>, <C-x>, <S-Esc> - open command window (`<C-f>` in Vim)
cnoremap <C-CR>  <C-f>
cnoremap <S-CR>  <C-f>
cnoremap <C-x>   <C-f>
cnoremap <S-Esc> <C-f>

cnoremap <C-Tab> <C-d>

cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>

" <C-k> - delete to the end of line
" NOTE: the default use of <C-k> in Cmdline mode in Vim is to enter
"   "digraphs"
cnoremap <C-k> <C-\>estrpart(getcmdline(),0,getcmdpos()-1)<CR>

" <C-Ins> - insert a "digraph" (`<C-k>` in Vim); hardly needed, but
"           let it be
cnoremap <C-Ins> <C-k>

" `<C-d>` - behave like in *tcsh*: delete a letter after the cursor
"           unless at the end of line, otherwise list all possible
"           completions (like `<C-d>` in Vim)
cnoremap <expr> <C-d> (getcmdpos()==len(getcmdline())+1?'<C-d>':'<Del>')

"
" #.# Experiments
" -------------------------------------------------------------------------
onoremap <SID>key_h i
onoremap <SID>key_H a
nnoremap <A-Tab>   <C-w>w
nnoremap <S-A-Tab> <C-w>W

"
" #.# Common modifier key combinations
" -------------------------------------------------------------------------
"
" XXX: most of this section has been copy-pasted
" TODO: test, fix, and improve these mappings
"
" #.#.# More custom mappings
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
" Bubble single lines
" XXX: depends on "unimpaired" plugin, does not work after "mapclear"
map <SID>unimpairedMoveUp   <Plug>unimpairedMoveUp
map <SID>unimpairedMoveDown <Plug>unimpairedMoveDown

" Map command-[ and command-] to indenting or outdenting
" while keeping the original selection in visual mode
vnoremap <A-]> >gv
vnoremap <A-[> <gv
vnoremap <C-A-Right> >gv
vnoremap <C-A-Left>  <gv

nnoremap <A-]> >>
nnoremap <A-[> <<
nnoremap <C-A-Right> >>
nnoremap <C-A-Left>  <<

onoremap <A-]> >>
onoremap <A-[> <<
onoremap <C-A-Right> >>
onoremap <C-A-Left>  <<

inoremap <A-]> <C-t>
inoremap <A-[> <C-d>
inoremap <C-A-Right> <C-t>
inoremap <C-A-Left>  <C-d>

if !has("gui_running")
  vnoremap <C-Right> >gv
  vnoremap <C-Left>  <gv

  nnoremap <C-Right> >>
  nnoremap <C-Left>  <<

  onoremap <C-Right> >>
  onoremap <C-Left>  <<

  inoremap <C-Right> <C-t>
  inoremap <C-Left>  <C-d>
endif

" Bubble single lines
" XXX: depends on "unimpaired" plugin, does not work after "mapclear"
nnoremap <script> <C-A-Up>   <SID>unimpairedMoveUp
nnoremap <script> <C-A-Down> <SID>unimpairedMoveDown

" Bubble multiple lines
" XXX: depends on "unimpaired" plugin, does not work after "mapclear"
vnoremap <script> <C-A-Up>   <SID>unimpairedMoveUpgv
vnoremap <script> <C-A-Down> <SID>unimpairedMoveDowngv

" Make Shift-Insert work like in Xterm
noremap  <S-Ins> <MiddleMouse>
noremap! <S-Ins> <MiddleMouse>

if (has('gui_macvim') && has('gui_running')) || exists('neovim_dot_app')
  " Map Command-# to switch tabs
  noremap  <D-0> 0gt
  inoremap <D-0> <Esc>0gt
  noremap  <D-1> 1gt
  inoremap <D-1> <Esc>1gt
  noremap  <D-2> 2gt
  inoremap <D-2> <Esc>2gt
  noremap  <D-3> 3gt
  inoremap <D-3> <Esc>3gt
  noremap  <D-4> 4gt
  inoremap <D-4> <Esc>4gt
  noremap  <D-5> 5gt
  inoremap <D-5> <Esc>5gt
  noremap  <D-6> 6gt
  inoremap <D-6> <Esc>6gt
  noremap  <D-7> 7gt
  inoremap <D-7> <Esc>7gt
  noremap  <D-8> 8gt
  inoremap <D-8> <Esc>8gt
  noremap  <D-9> 9gt
  inoremap <D-9> <Esc>9gt
else
  " Map Control-# to switch tabs
  noremap  <C-0> 0gt
  inoremap <C-0> <Esc>0gt
  noremap  <C-1> 1gt
  inoremap <C-1> <Esc>1gt
  noremap  <C-2> 2gt
  inoremap <C-2> <Esc>2gt
  noremap  <C-3> 3gt
  inoremap <C-3> <Esc>3gt
  noremap  <C-4> 4gt
  inoremap <C-4> <Esc>4gt
  noremap  <C-5> 5gt
  inoremap <C-5> <Esc>5gt
  noremap  <C-6> 6gt
  inoremap <C-6> <Esc>6gt
  noremap  <C-7> 7gt
  inoremap <C-7> <Esc>7gt
  noremap  <C-8> 8gt
  inoremap <C-8> <Esc>8gt
  noremap  <C-9> 9gt
  inoremap <C-9> <Esc>9gt
endif

"
" #.# Unused keys
" -------------------------------------------------------------------------
"
vnoremap <Tab> <Nop>
noremap <SID>key_'<BS> <Nop>
vnoremap <SID>key_g <Nop>
onoremap <SID>key_g <Nop>
onoremap <SID>key_G <Nop>
vnoremap <SID>key_w <Nop>
vnoremap <SID>key_W <Nop>
onoremap <SID>key_w <Nop>
onoremap <SID>key_W <Nop>
vnoremap <SID>key_e <Nop>
vnoremap <SID>key_E <Nop>
onoremap <SID>key_e <Nop>
onoremap <SID>key_E <Nop>

"-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
"
"
" =========================================================================
" # Notes                                                           [notes]
" =========================================================================
"
"
" #.# Observed patterns
" -------------------------------------------------------------------------
"
"  * `<t,T>` and `<y,Y>` are reserved for user-defined commands.
"
"  * `<@>`, `<#>`, `<$>` are for repeating actions.
"
"  * `<^>`, `<&>`, `<*>`, `<(>`, `<)>`, `<->`, `<=>`, `<+>` are "GoTo"
"    commands.
"
"  * `<s,S>`, `<d,D>`, `<f,F>`, `<g,G>` are for common editing operations
"
"  * `<x,X>` and `<c,C>` are complementary.
"
"  * `<,,<>` and `<.,>>` are complementary.
"
"  * `<$>` and `<%>` are for "substitute" (find-and-replace).
"
"  * `<a,A>`, `<s,S>`, `<d,D>` use registers.
"
"
" #.# To do
" -------------------------------------------------------------------------
"
"  * Create good mappings of `<[>`, `<]>`, `<{>`, `<}>`, `<(>`, `<)>`.
"
"  * Think how to be with modifier of type `i`, `a`.
"
"  * Consider using `<w>` and `<e>` in operator pending mode as modifiers.
"
"
" #.# To think about
" -------------------------------------------------------------------------
"
"  * In some cases, modifier suffix would be more appropriate than modifier
"    prefix.
"
"-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
