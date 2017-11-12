class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
         
         ROLES = ['admin', 'employee']
         has_many :requests
        
         
         def admin?
           role == "admin"
         end
         
         def employee?
           role == "employee"
         end
end
