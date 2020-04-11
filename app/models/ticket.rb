class Ticket < ApplicationRecord
  belongs_to :order
  belongs_to :ticket_type

  before_save :update_stats
  before_destroy :update_stats

  private
    def update_stats
      es = self.ticket_type.event.event_stat
      if ticket.save?
        self.event_stat=( es.tickets_sold+1), (es.attendance +1)
      end
      if ticket.destroy?
        self.event_stat=( es.tickets_sold-1), (es.attendance -1)
      end
      if es.tickets_sold>es.capacity?
        errors.add(:capacity, "the number of tickets sold exceeds the capacity of the event venue")
      end
    end
end
