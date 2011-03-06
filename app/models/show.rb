class Show < ActiveRecord::Base
  belongs_to :coordinator
  belongs_to :venue

  validates :name, :presence => true, :length => { :minimum => 1, :maximum => 40 }
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :next_start_date, :presence => true
  validates :next_end_date, :presence => true
  validates :coordinator_id, :presence => true
  validates :venue_id, :presence => true

  scope :ordered_by_name, order("shows.name ASC")
  scope :filtered, lambda { | search | { :conditions => [ "name LIKE ?", "%#{search}%" ]}}

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
end
