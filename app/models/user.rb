class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
         has_many :requests
        
         
         def admin?
           role == "admin"
         end
         
         def creator?
           role == "creator"
         end
         
         def operator?
           role == "operator"
         end
         
         def mechanic?
           role == "mechanic"
         end
end
