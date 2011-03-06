module RegularExpressions

  RePhone = /\A((\(\d{3}\))|(\d{3}))[ -]\d{3}[ -]\d{4}\z/

  ReEmail = %r{
   \A # Start of string
 
   [0-9a-zA-Z] # First character
   [0-9a-zA-Z_'.+-]+ # Middle characters
   [0-9a-zA-Z] # Last character
 
   @ # Separating @ character
 
   [0-9a-z] # Domain name begin
   [0-9a-z.-]+ # Domain name middle
   [0-9a-z] # Domain name end
 
   \z # End of string
 }xi # Case insensitive

  RePostalCode = /\A\d{5}(-\d{1,4})?\z/
end
