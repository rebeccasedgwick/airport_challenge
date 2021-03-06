require "airport"

describe Airport do
  let(:plane) { Plane.new }

  describe "#land" do
    context "during sunny weather" do
      before do
        allow_any_instance_of(Weather).to receive(:report).and_return("sunny")
      end

      it "allows a plane to land" do
        expect(subject).to respond_to(:land).with(1).argument
      end

      it "stores the planes that have landed" do
        subject.land(plane)
        expect(subject.hangar).to include(plane)
      end

      it "prevents landing when the airport is full" do
        subject.capacity.times { subject.land(plane) }
        expect { subject.land(plane) }.to raise_error("Error: airport is full")
      end

      context "when the airport capacity is >1 (else airport.full? to superceed)" do
        let(:airport) { Airport.new(2) }

        it "prevents landing if the plane has already landed" do
          airport.land(plane)
          expect { airport.land(plane) }.to raise_error("Plane already in airport")
        end
      end
    end

    context "during stormy weather" do
      before do
        allow_any_instance_of(Weather).to receive(:report).and_return("stormy")
      end

      it "raises an error" do
        expect { subject.land(plane) }.to raise_error("Too stormy to land!")
      end
    end
  end

  describe "#takeoff" do
    context "during sunny weather" do
      before do
        allow_any_instance_of(Weather).to receive(:report).and_return("sunny")
      end

      it "returns a message confirming plane has gone when plane takes off" do
        subject.land(plane)
        expect(subject.takeoff(plane)).to eq "#{plane} has taken off"
      end

      it "removes a plane that has just taken off from the airport hangar" do
        subject.land(plane)
        subject.takeoff(plane)
        expect(subject.hangar).not_to include(plane)
      end

      it "prevents takeoff if the plane is not in the airport @hangar" do
        expect { subject.takeoff(plane) }.to raise_error("Error: plane is not at the airport")
      end
    end

    context "during stormy weather" do
      before do
        allow_any_instance_of(Weather).to receive(:report).and_return("stormy")
      end

      it "raises an error" do
        expect { subject.takeoff(plane) }.to raise_error("Too stormy to take off!")
      end
    end
  end

  describe "#capacity" do
    it "shows the default airport capacity" do
      capacity = Airport::DEFAULT_CAPACITY
      expect(subject.capacity).to eq capacity
    end

    it "allows a user to override the default and set the capacity" do
      new_capacity = 20
      airport = Airport.new(new_capacity)
      expect(airport::capacity).to eq new_capacity
    end
  end
end
