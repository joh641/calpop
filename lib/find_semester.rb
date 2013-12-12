module FindSemester

  # finds the semester based on date
  def find_semester(date)
    month = date.month
    day = date.day
    if month >= 8 and day >= 15
      "Fall"
    elsif month >= 5 and day >= 20
      "Summer"
    else
      "Spring"
    end
  end

end
