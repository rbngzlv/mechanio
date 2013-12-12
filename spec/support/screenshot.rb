module ScreenshotHelper
  def screen
    @count ||= 0
    @count += 1
    page.driver.render(Rails.root.join("tmp", "screenshots/#{@count}.png"), full: true)
  end
end
