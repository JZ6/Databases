import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ElectionInfo extends JDBCSubmission {

	public ElectionInfo() throws ClassNotFoundException {

		Class.forName("org.postgresql.Driver");
	}

	public static void main(String[] args) throws Exception {
		//Write code here.
		System.out.println("Hellow World");
	}

	@Override
	public boolean connectDB(String url, String username, String password) {
		try {
			connection = DriverManager.getConnection(url, username, password);
		} catch (SQLException ex) {
			return false;
		}
		return true;
	}

	@Override
	public boolean disconnectDB() {
		try {
			connection.close();
		} catch (SQLException e) {
			return false;
		}
		return true;
	}

	@Override
	public ElectionResult presidentSequence(String countryName) {
		ElectionResult res = new ElectionResult(new ArrayList<Integer>(), new ArrayList<String>());

		//Find president and party name in country sorted by start date
		String statement = "SELECT politician_president.id AS president_id,party.name AS party_name " +
				"FROM country JOIN politician_president ON country.id = politician_president.country_id " +
				"JOIN party ON politician_president.party_id = party.id WHERE country.name = (?) " +
				"ORDER by politician_president.start_date DESC";

		try {

			PreparedStatement pstatement = super.connection.prepareStatement(statement);
			pstatement.setString(1, countryName.trim());
			ResultSet estatement = pstatement.executeQuery();

			while (estatement.next()) {
				res.presidents.add(estatement.getInt(1));
				res.parties.add(estatement.getString(2));
			}

			return res;

		} catch (SQLException e) {
			return null;
		}
	}

	@Override
	public List<Integer> findSimilarParties(Integer partyId, Float threshold) {
		List<Integer> res = new ArrayList<Integer>();
		List<Integer> debug = new ArrayList<Integer>();
		debug.add(1);

		try {
			//Original party
			PreparedStatement pstatement = super.connection.prepareStatement("SELECT id,description FROM party WHERE id=" + partyId.toString() + "; ");
			//pstatement.setInt(1, partyId);
			ResultSet estatement = pstatement.executeQuery();

			String original = "";
			while (estatement.next()) {
				original = estatement.getString(2);
			}

			//Other Parties to compare to
			PreparedStatement opstatement = super.connection.prepareStatement("SELECT id,description FROM party; ");
			ResultSet oestatement = opstatement.executeQuery();

			while (oestatement.next()) {
				if (similarity(oestatement.getString(2), original) >= threshold) {
					res.add(oestatement.getInt(1));
				}
			}
			//Remove Original party
			res.remove(res.indexOf(partyId));

			return res;

		} catch (SQLException e) {
			debug.add(e.getErrorCode());
			debug.add(partyId);
			return debug;
		}
	}
}



