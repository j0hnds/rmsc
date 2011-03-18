class Show < ActiveRecord::Base
  belongs_to :coordinator
  belongs_to :venue
  has_many :registrations
  has_many :exhibitors, :through => :registrations
  has_many :rooms, :through => :registrations
  has_many :attendances
  has_many :buyers, :through => :attendances

  validates :name, :presence => true, :length => { :minimum => 1, :maximum => 40 }
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :next_start_date, :presence => true
  validates :next_end_date, :presence => true
  validates :coordinator_id, :presence => true
  validates :venue_id, :presence => true

  scope :ordered_by_name, order("shows.name ASC")
  scope :ordered_by_most_recent, order('shows.start_date DESC')
  scope :filtered, lambda { | search | { :conditions => [ "name LIKE ?", "%#{search}%" ]}}
  scope :latest_show, order("shows.start_date DESC, shows.id DESC").limit(1)

  @@per_page = 30

  def set_default_show_dates
    self.start_date, self.end_date = show_dates_after_date(Date.today)
    self.next_start_date, self.next_end_date = show_dates_after_date(self.start_date)
  end

  def show_dates_after_date(date)
    if date.month >= 9
      # Fine, that must mean the show date is sometime in March; first weekend
      next_show = Date.new(date.year + 1, 3, 1)
      while next_show.wday != 6
        next_show += 1.day
      end
      [ next_show, next_show + 1.day ]
    else
      # OK, that must mean the show date is sometime in September; second weekend
      next_show = Date.new(date.year, 9, 1)
      num_saturdays = 0
      while num_saturdays < 2
        next_show += 1.day
        num_saturdays += 1 if next_show.wday == 6
      end
      [ next_show, next_show + 1.day ]
    end
  end

  def register_exhibitor(exhibitor, lines=nil, associates=nil)
    registration = Registration.create(:show => self, :exhibitor => exhibitor)

    registration.initialize_registration(lines, associates)

    registration
  end

  def number_of_lines
    count = 0
    self.rooms.each do | room |
      count += room.lines.size
    end
    count
  end

  def number_of_stores
    self.buyers.collect(&:store_id).uniq.size
  end

  def number_of_exhibitors
    self.exhibitors.size
  end
end
